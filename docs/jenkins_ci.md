# URL for Jenkins

-     External/public - http://173.39.214.186/
-     GitHub - https://github.com/CiscoCloud/microservices-infrastructure/

# Steps to create account

Anonymous access is granted with permissions to view all jobs/reports/logs.

To get a specific/admin access to Jenkins please sign up - click on a link "**Create an account if you are not a member yet.**"

Fill the form, sign up and send an e-mail to the following DL asking to get access: [mi-build-notifications](mi-build-notifications@external.cisco.com)

# Steps to test a branch

Currently workflow is:

1. All jobs are tied to the particular GitHUB branch and tenant.
2. It has two types of jobs:

    - triggered by **PR (pull request)** to the particular branch
    - triggered by **commit** to the particular branch

3. These triggers automate the whole testing process.
4. We're using following naming template for jobs:

    -     **View** reflects the particular tenant which was used for deployment process, it gathers all jobs tied to this tenant.
    -     Trigger type - **COMMIT** for commit trigger, job can be started manually, **PR** for pull request trigger, job can't be started manually.
    -     Branch name which is being tested by job, e.g. **master** or **qa-integration**
    -     QA Tenant name where job is restricted to run, e.g. **CCS-MI-US-INTERNAL-1-QA-1**
    -     Job named as **destroy** destroys cluster in the given tenant. This job starts as a madnatory post-build step of deploying job. This job could be started manually.

So you get the main idea of job naming conventions.

# Mail List for Jenkins notifications and how to subscribe to it (using mailer.cisco.com) 

Mail list is:  [mi-build-notifications](mi-build-notifications@external.cisco.com)

# Steps to check if Master branch failed or not (and all test runs)

Job which are triggered by commit to the particular branch can be started manually on demand.

Job is configurable an pretty flexible and it has the next main steps:

1.     Grabs the code base from GitHub
2.     Configures tenant
3.     Deploys configured cluster and run smoke tests
4.     Runs automated tests (robot-framework) (in case cluster is successfully deployed and smoke testing is done)
5.     Gathers reports, console logs
6.     Destroys cluster

To start test deployment the next few steps have to be done:

1.     Open a particular view with tenant to test cluster deployment
2.     Choose which branch you want run deployment for test
3.     Start testing by pushing "Play" button

# Steps to check issues (if any) during last (current) test

TBD

# Steps to see tests of all pull requests to mater branch and see any issues

TBD

