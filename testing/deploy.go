package main

import (
	"github.com/drone/drone-go/drone"
	"github.com/drone/drone-go/plugin"
	"io/ioutil"
	"log"
	"os"
	"os/exec"
	"strconv"
	"strings"
)

type Vargs struct {
	TerraformVarsFile string `json:"terraform.tfvars"`
	TerraformFile     string `json:"terraform.tf"`
	AnsiblePlaybook   string `json:"terraform.yml"`
}

func main() {
	var (
		repo      = new(drone.Repo)
		build     = new(drone.Build)
		sys       = new(drone.System)
		workspace = new(drone.Workspace)
		vargs     = new(Vargs)
	)

	plugin.Param("build", build)
	plugin.Param("repo", repo)
	plugin.Param("system", sys)
	plugin.Param("workspace", workspace)
	plugin.Param("vargs", vargs)

	err := plugin.Parse()
	if err != nil {
		log.Fatal(err)
	}

	vargs.TerraformVarsFile = strings.Join([]string{vargs.TerraformVarsFile, "\nbuild_number = \"", strconv.Itoa(build.Number), "\""}, "")

	err = CheckDeploy(vargs)
	if err != nil {
		log.Fatal(err)
		os.Exit(1)
	} else {
		os.Exit(0)
	}

}

func CheckDeploy(vargs *Vargs) error {
	// 1. Write contents of tfvars to disk
	log.Print(vargs.TerraformVarsFile)
	err := ioutil.WriteFile("terraform.tfvars", []byte(vargs.TerraformVarsFile), 0644)

	var (
		an_private_key = "--private_key ~/.ssh/id_rsa"
		an_extra_vars  = "--extra-vars=@security.yml"
	)
	// we need to repeat this command for a bug in terraform aws provider
	defer repeatCommandOnFail(3, []string{"terraform", "destroy", "-force"})

	// we only want to run the provision step if the previous steps succeed
	// the provision step at this time is time-costly
	// this may not be idiomatic
	var commandQueue = [][]string{
		[]string{"terraform", "get"},
		[]string{"terraform", "apply"},
		[]string{"ansible-playbook", an_private_key, "playbooks/wait-for-hosts.yml"},
		[]string{"ansible-playbook", an_private_key, an_extra_vars, vargs.AnsiblePlaybook},
	}

	err = runCommandQueue(commandQueue)

	// 4. TODO: Run health checks, porting python script to go
	// 5. TODO: Test other playbooks, need to write tests first
	return err
}

func runCommandQueue(commands [][]string) error {
	var err error
	for _, command := range commands {
		err = runCommand(command)
		if err != nil {
			break
		}
	}
	return err
}

func runCommand(command []string) error {
	log.Printf("CMD: %s", strings.Join(command, " "))
	cmd := exec.Command(command[0])
	cmd.Args = command
	cmd.Stdin = os.Stdin
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr

	err := cmd.Run()
	return err
}

func repeatCommandOnFail(repeats int, command []string) error {
	var err error
	for i := 0; i < repeats; i++ {
		err = runCommand(command)

		// if command is successful, don't repeat execution
		if err != nil {
			log.Printf("CMD FAILED ON TRY: %d", i+1)
		} else {
			return err
		}
	}

	return err
}
