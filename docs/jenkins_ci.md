# URL for Jenkins

-     External/public - http://173.39.214.186/
-     GitHUB - https://github.com/CiscoCloud/microservices-infrastructure/

# Steps to create account

Anonymous access is granted for read for all jobs/reports/logs.

To get the specific/admin access to the Jenkins please sign up - click on link "**Create an account if you are not a member yet.**"

Fill the form, sign up and send the message to the maintainers who are able to grant access, the following email can be used [mi-build-notifications](mi-build-notifications@external.cisco.com)

# Steps to test a branch

Current workflow is the following:

1.     All jobs are tied to the particular GitHUB branch and tenant:
1.     It has two types of jobs:

    1.     triggered by PR (pull request) to the particular branch
    1.     triggered by commit to the particular branch

1.     Mentioned triggers are automate all testing process.
1.     All jobs has the naming template shown below:


-     **View** reflects the particular tenant which was used for deployment process, gather all jobs tied to this tenant.
-     Branch name which job controls, e.g. **master**
-     Trigger type - **provision** for commit trigger, ++job can be started manually++, pr-provision for **PR** trigger, ++job mustn't be started manually++.
-     Tenant name where job is restricted to run, e.g. **CCS-MI-US-INTERNAL-1-QA-1**
-     Job which **destroys** cluster in the tenant, it starts always as post build step of deploying job, job can be started manually.

So you get the main idea of job naming.

# Mail List for Jenkins notifications and how to subscribe to it (using mailer.cisco.com) 

Mail list is:  [mi-build-notifications](mi-build-notifications@external.cisco.com)

# Steps to check if Master branch failed or not (and all test runs)

Job which are triggered by commit to the particular branch can be started manually on demand.

Job is configurable an pretty flexible and it has the next main steps:

1.     Grabs the code base from GitHUB
1.     Configures tenant
1.     Deploys configured cluster and run smoke testing
1.     Runs automated tests (robot-framework) in case we have successfully deployed cluster
1.     Gathers reports
1.     Destroys cluster

To start test deployment the next few steps have to be done:

1.     Open the particular view with tenant to test cluster deployment
1.     Choose which branch you want test
1.     Start testing by pushing the button play

# Steps to check issues (if any) during last (current) test

TBD

# Steps to see tests of all pull requests to mater branch and see any issues

TBD

