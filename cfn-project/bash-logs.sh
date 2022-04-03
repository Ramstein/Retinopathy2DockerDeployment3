ec2-user:~/environment $ aws s3 cp ~/environment/LearningEB/cfn-project/template.yaml s3://studysync/template.yaml --region us-east-1
upload failed: LearningEB/cfn-project/template.yaml to s3://studysync/template.yaml An error occurred (AccessDenied) when calling the PutObject operation: Access Denied
ec2-user:~/environment $ aws s3 cp ~/environment/LearningEB/cfn-project/template.yaml s3://studysync/template.yaml --region us-east-1
upload failed: LearningEB/cfn-project/template.yaml to s3://studysync/template.yaml An error occurred (AccessDenied) when calling the PutObject operation: Access Denied
ec2-user:~/environment $ aws s3 cp ~/environment/LearningEB/cfn-project/template.yaml s3://studysync/template.yaml --region us-east-1
upload failed: LearningEB/cfn-project/template.yaml to s3://studysync/template.yaml An error occurred (AccessDenied) when calling the PutObject operation: Access Denied
ec2-user:~/environment $ aws s3 cp ~/environment/LearningEB/cfn-project/template.yaml s3://studysync/template.yaml --region us-east-1
upload failed: LearningEB/cfn-project/template.yaml to s3://studysync/template.yaml An error occurred (AccessDenied) when calling the PutObject operation: Access Denied
ec2-user:~/environment $ aws s3 cp ~/environment/LearningEB/cfn-project/template.yaml s3://studysync/template.yaml
upload failed: LearningEB/cfn-project/template.yaml to s3://studysync/template.yaml An error occurred (AccessDenied) when calling the PutObject operation: Access Denied
ec2-user:~/environment $ ls
LearningEB  README.md
ec2-user:~/environment $ cd ..
ec2-user:~ $ ls
environment  node_modules  package.json  package-lock.json
ec2-user:~ $ cd environment/
ec2-user:~/environment $ ls
LearningEB  README.md
ec2-user:~/environment $ cd ..
ec2-user:~ $ cd ..
ec2-user:/home $ ls
ec2-user
ec2-user:/home $ cd ..
ec2-user:/ $ ls
bin  boot  dev  etc  home  lib  lib64  local  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var
ec2-user:/ $ ls -la
total 20
dr-xr-xr-x  18 root root  257 Mar 24 21:36 .
dr-xr-xr-x  18 root root  257 Mar 24 21:36 ..
-rw-r--r--   1 root root    0 Mar 24 21:36 .autorelabel
lrwxrwxrwx   1 root root    7 Mar 16 01:51 bin -> usr/bin
dr-xr-xr-x   4 root root 4096 Mar 16 01:52 boot
drwxr-xr-x  14 root root 2860 Apr  2 11:08 dev
drwxr-xr-x  98 root root 8192 Apr  2 11:08 etc
drwxr-xr-x   3 root root   22 Mar 24 21:36 home
lrwxrwxrwx   1 root root    7 Mar 16 01:51 lib -> usr/lib
lrwxrwxrwx   1 root root    9 Mar 16 01:51 lib64 -> usr/lib64
drwxr-xr-x   2 root root    6 Mar 16 01:51 local
drwxr-xr-x   2 root root    6 Apr  9  2019 media
drwxr-xr-x   2 root root    6 Apr  9  2019 mnt
drwxr-xr-x   6 root root   55 Mar 24 21:52 opt
dr-xr-xr-x 119 root root    0 Apr  2 11:08 proc
dr-xr-x---   5 root root  132 Mar 24 21:49 root
drwxr-xr-x  35 root root 1160 Apr  2 11:08 run
lrwxrwxrwx   1 root root    8 Mar 16 01:51 sbin -> usr/sbin
drwxr-xr-x   2 root root    6 Apr  9  2019 srv
dr-xr-xr-x  13 root root    0 Apr  2 11:08 sys
drwxrwxrwt  11 root root 4096 Apr  2 11:38 tmp
drwxr-xr-x  13 root root  155 Mar 16 01:51 usr
drwxr-xr-x  20 root root  296 Mar 24 21:48 var
ec2-user:/ $ cd home/
ec2-user:/home $ ls -la
total 4
drwxr-xr-x  3 root     root       22 Mar 24 21:36 .
dr-xr-xr-x 18 root     root      257 Mar 24 21:36 ..
drwx------ 11 ec2-user ec2-user 4096 Apr  2 11:35 ec2-user
ec2-user:/home $ cd ec2-user/
ec2-user:~ $ ls -la
total 60
drwx------ 11 ec2-user ec2-user 4096 Apr  2 11:35 .
drwxr-xr-x  3 root     root       22 Mar 24 21:36 ..
drwxr-xr-x  2 ec2-user ec2-user   25 Apr  2 11:36 .aws
-rw-------  1 ec2-user ec2-user 1235 Apr  2 11:40 .bash_history
-rw-r--r--  1 ec2-user ec2-user   18 Jul 15  2020 .bash_logout
-rw-r--r--  1 ec2-user ec2-user  336 Mar 24 21:55 .bash_profile
-rw-r--r--  1 ec2-user ec2-user 1659 Mar 24 21:55 .bashrc
lrwxrwxrwx  1 ec2-user ec2-user    7 Mar 24 21:51 .c9 -> /opt/c9
drwxr-xr-x  4 ec2-user ec2-user   52 Apr  2 11:09 environment
drwxrwxr-x  3 ec2-user ec2-user   19 Mar 24 21:56 .gem
-rw-rw-r--  1 ec2-user ec2-user  102 Apr  2 11:35 .gitconfig
drwx------  2 ec2-user ec2-user   99 Mar 24 21:55 .gnupg
-rw-rw-r--  1 ec2-user ec2-user  118 Mar 24 21:55 .mkshrc
drwxrwxr-x  7 ec2-user ec2-user  102 Apr  2 11:11 node_modules
drwxrwxr-x  4 ec2-user ec2-user   72 Mar 24 21:48 .npm
-rw-------  1 ec2-user ec2-user   16 Mar 24 21:55 .npmrc
drwxrwxr-x  8 ec2-user ec2-user 4096 Mar 24 21:47 .nvm
-rw-rw-r--  1 ec2-user ec2-user  102 Apr  2 11:11 package.json
-rw-rw-r--  1 ec2-user ec2-user 2154 Apr  2 11:11 package-lock.json
-rw-rw-r--  1 ec2-user ec2-user  236 Mar 24 21:55 .profile
drwxrwxr-x 25 ec2-user ec2-user 4096 Mar 24 21:55 .rvm
drwxr-xr-x  2 ec2-user ec2-user   29 Mar 24 21:36 .ssh
-rw-rw-r--  1 ec2-user ec2-user  118 Mar 24 21:55 .zlogin
-rw-rw-r--  1 ec2-user ec2-user  118 Mar 24 21:55 .zshrc
ec2-user:~ $ cd .aws
ec2-user:~/.aws $ ls
credentials
ec2-user:~/.aws $ c9 credentials 
ec2-user:~/.aws $ aws s3 cp ~/environment/LearningEB/cfn-project/template.yaml s3://studysync/template.yaml --region us-east-1
upload failed: ../environment/LearningEB/cfn-project/template.yaml to s3://studysync/template.yaml An error occurred (InvalidToken) when calling the PutObject operation: The provided token is malformed or otherwise invalid.
ec2-user:~/.aws $ aws s3 cp ~/environment/LearningEB/cfn-project/template.yaml s3://studysync/template.yaml --region us-east-1
upload failed: ../environment/LearningEB/cfn-project/template.yaml to s3://studysync/template.yaml An error occurred (AccessDenied) when calling the PutObject operation: Access Denied
ec2-user:~/.aws $ aws s3 cp ~/environment/LearningEB/cfn-project/template.yaml s3://studysync/template.yaml --region us-east-1
upload failed: ../environment/LearningEB/cfn-project/template.yaml to s3://studysync/template.yaml An error occurred (AccessDenied) when calling the PutObject operation: Access Denied
ec2-user:~/.aws $ aws s3 cp ~/environment/LearningEB/cfn-project/template.yaml s3://studysync/template.yaml
upload failed: ../environment/LearningEB/cfn-project/template.yaml to s3://studysync/template.yaml An error occurred (AccessDenied) when calling the PutObject operation: Access Denied
ec2-user:~/.aws $ aws s3 cp ~/environment/LearningEB/cfn-project/template.yaml s3://studysync/template.yaml
upload failed: ../environment/LearningEB/cfn-project/template.yaml to s3://studysync/template.yaml An error occurred (AccessDenied) when calling the PutObject operation: Access Denied
ec2-user:~/.aws $ aws s3 cp ~/environment/LearningEB/cfn-project/template.yaml s3://studysync/template.yaml
upload failed: ../environment/LearningEB/cfn-project/template.yaml to s3://studysync/template.yaml An error occurred (AccessDenied) when calling the PutObject operation: Access Denied
ec2-user:~/.aws $ aws s3 cp ~/environment/LearningEB/cfn-project/template.yaml s3://studysync-cfn/template.yaml
upload: ../environment/LearningEB/cfn-project/template.yaml to s3://studysync-cfn/template.yaml
ec2-user:~/.aws $ aws s3 cp ~/environment/LearningEB/cfn-project/template.yaml s3://studysync-cfn/template.yaml
upload: ../environment/LearningEB/cfn-project/template.yaml to s3://studysync-cfn/template.yaml
ec2-user:~/.aws $ aws s3 cp ~/environment/LearningEB/cfn-project/template.yaml s3://studysync-cfn/template.yaml
upload: ../environment/LearningEB/cfn-project/template.yaml to s3://studysync-cfn/template.yaml
ec2-user:~/.aws $ aws s3 cp ~/environment/LearningEB/cfn-project/template.yaml s3://studysync-cfn/template.yaml
upload: ../environment/LearningEB/cfn-project/template.yaml to s3://studysync-cfn/template.yaml
ec2-user:~/.aws $ aws s3 cp ~/environment/LearningEB/cfn-project/template.yaml s3://studysync-cfn/template.yaml
upload: ../environment/LearningEB/cfn-project/template.yaml to s3://studysync-cfn/template.yaml
ec2-user:~/.aws $ npm i cfn-lint -g
npm WARN deprecated core-js@2.6.12: core-js@<3.4 is no longer maintained and not recommended for usage due to the number of issues. Because of the V8 engine whims, feature detection in old core-js versions could cause a slowdown up to 100x even if nothing is polyfilled. Please, upgrade your dependencies to the actual version of core-js.

added 75 packages, and audited 76 packages in 4s

1 package is looking for funding
  run `npm fund` for details

7 vulnerabilities (3 low, 4 high)

To address all issues (including breaking changes), run:
  npm audit fix --force

Run `npm audit` for details.
ec2-user:~/.aws $ ls
credentials
ec2-user:~/.aws $ cd ..
ec2-user:~ $ ls
environment  node_modules  package.json  package-lock.json
ec2-user:~ $ cd environment/LearningEB/cfn-project/
ec2-user:~/environment/LearningEB/cfn-project (main) $ ls
create.sh  template.yaml  update.sh
ec2-user:~/environment/LearningEB/cfn-project (main) $ cfn-lint validate template.yaml 
0 infos
0 warn
0 crit
Template valid!
ec2-user:~/environment/LearningEB/cfn-project (main) $ cfn-lint validate template.yaml 
0 infos
0 warn
0 crit
Template valid!
ec2-user:~/environment/LearningEB/cfn-project (main) $ cfn-lint validate template.yaml 
Unable to parse template! Use --verbose for more information.
ec2-user:~/environment/LearningEB/cfn-project (main) $ cfn-lint validate template.yaml 
Unable to parse template! Use --verbose for more information.
ec2-user:~/environment/LearningEB/cfn-project (main) $ cfn-lint validate template.yaml --verbose
Unable to parse template! Use --verbose for more information.
Error: Could not determine file type. Check your template is not malformed. can not read an implicit mapping pair; a colon is missed in "template.yaml" at line 27, column 40:
     ...              CidrIp; "0.0.0.0/0"
                                         ^
    at Object.openFile (/home/ec2-user/.nvm/versions/node/v16.14.2/lib/node_modules/cfn-lint/src/parser.ts:25:15)
    at Object.validateFile (/home/ec2-user/.nvm/versions/node/v16.14.2/lib/node_modules/cfn-lint/src/validator.ts:93:27)
    at Command.<anonymous> (/home/ec2-user/.nvm/versions/node/v16.14.2/lib/node_modules/cfn-lint/src/index.ts:122:32)
    at Command.listener (/home/ec2-user/.nvm/versions/node/v16.14.2/lib/node_modules/cfn-lint/node_modules/commander/index.js:315:8)
    at Command.emit (node:events:526:28)
    at Command.parseArgs (/home/ec2-user/.nvm/versions/node/v16.14.2/lib/node_modules/cfn-lint/node_modules/commander/index.js:651:12)
    at Command.parse (/home/ec2-user/.nvm/versions/node/v16.14.2/lib/node_modules/cfn-lint/node_modules/commander/index.js:474:21)
    at Object.<anonymous> (/home/ec2-user/.nvm/versions/node/v16.14.2/lib/node_modules/cfn-lint/src/index.ts:191:9)
    at Module._compile (node:internal/modules/cjs/loader:1103:14)
    at Object.Module._extensions..js (node:internal/modules/cjs/loader:1157:10)
ec2-user:~/environment/LearningEB/cfn-project (main) $ cfn-lint validate template.yaml --verbose
0 infos
0 warn
0 crit
Template valid!
ec2-user:~/environment/LearningEB/cfn-project (main) $ chmod u+x update.sh 
ec2-user:~/environment/LearningEB/cfn-project (main) $ chmod u+x create.sh 
ec2-user:~/environment/LearningEB/cfn-project (main) $ ./update.sh 
upload: ./template.yaml to s3://studysync-cfn/template.yaml         
ec2-user:~/environment/LearningEB/cfn-project (main) $ ./update.sh 
upload: ./template.yaml to s3://studysync-cfn/template.yaml         
ec2-user:~/environment/LearningEB/cfn-project (main) $ ./update.sh 
upload: ./template.yaml to s3://studysync-cfn/template.yaml         
ec2-user:~/environment/LearningEB/cfn-project (main) $ ./update.sh 
upload: ./template.yaml to s3://studysync-cfn/template.yaml         

Error parsing parameter '--parameters': Expected: '<second>', received: '<none>' for input:
ParameterKey=VpcId,
                   ^
ec2-user:~/environment/LearningEB/cfn-project (main) $  cfn-lint validate template.yaml 
0 infos
0 warn
0 crit
Template valid!
ec2-user:~/environment/LearningEB/cfn-project (main) $ ./update.sh 
upload: ./template.yaml to s3://studysync-cfn/template.yaml         

Error parsing parameter '--parameters': Expected: '<second>', received: '<none>' for input:
ParameterKey=VpcId,
                   ^
ec2-user:~/environment/LearningEB/cfn-project (main) $ ./update.sh 
upload: ./template.yaml to s3://studysync-cfn/template.yaml         

An error occurred (ValidationError) when calling the UpdateStack operation: Invalid template resource property 'SecurityGroupIds'
ec2-user:~/environment/LearningEB/cfn-project (main) $ ./update.sh 
upload: ./template.yaml to s3://studysync-cfn/template.yaml         
{
    "StackId": "arn:aws:cloudformation:us-east-1:731417425637:stack/StudySync/b746ba30-b27b-11ec-824e-0a15535d307b"
}
ec2-user:~/environment/LearningEB/cfn-project (main) $ aws cloudformation describe-stacks --stack-name StudySync --output table
------------------------------------------------------------------------------------------------------------------------------------------
|                                                             DescribeStacks                                                             |
+----------------------------------------------------------------------------------------------------------------------------------------+
||                                                                Stacks                                                                ||
|+-----------------------------+--------------------------------------------------------------------------------------------------------+|
||  CreationTime               |  2022-04-02T11:52:53.634Z                                                                              ||
||  DeletionTime               |  2022-04-02T11:52:58.075Z                                                                              ||
||  Description                |  Infrastructure for StudySync                                                                          ||
||  DisableRollback            |  False                                                                                                 ||
||  EnableTerminationProtection|  False                                                                                                 ||
||  StackId                    |  arn:aws:cloudformation:ap-south-1:731417425637:stack/StudySync/6cf0e190-b27b-11ec-8a77-06abc5600c42   ||
||  StackName                  |  StudySync                                                                                             ||
||  StackStatus                |  ROLLBACK_COMPLETE                                                                                     ||
|+-----------------------------+--------------------------------------------------------------------------------------------------------+|
|||                                                          DriftInformation                                                          |||
||+---------------------------------------------------------------------------+--------------------------------------------------------+||
|||  StackDriftStatus                                                         |  NOT_CHECKED                                           |||
||+---------------------------------------------------------------------------+--------------------------------------------------------+||
|||                                                        RollbackConfiguration                                                       |||
||+------------------------------------------------------------------------------------------------------------------------------------+||
ec2-user:~/environment/LearningEB/cfn-project (main) $ aws cloudformation list-stack-resources --stack-name StudySync --output table                                                                                                                
----------------------------------------------------------------------------------------------
|                                     ListStackResources                                     |
+--------------------------------------------------------------------------------------------+
||                                  StackResourceSummaries                                  ||
|+---------------------------+--------------------+------------------+----------------------+|
||   LastUpdatedTimestamp    | LogicalResourceId  | ResourceStatus   |    ResourceType      ||
|+---------------------------+--------------------+------------------+----------------------+|
||  2022-04-02T11:53:01.751Z |  WebServer         |  DELETE_COMPLETE |  AWS::EC2::Instance  ||
|+---------------------------+--------------------+------------------+----------------------+|
|||                                    DriftInformation                                    |||
||+---------------------------------------------------------+------------------------------+||
|||  StackResourceDriftStatus                               |  NOT_CHECKED                 |||
||+---------------------------------------------------------+------------------------------+||
ec2-user:~/environment/LearningEB/cfn-project (main) $ aws cloudformation list-stack-resources --stack-name StudySync
{
    "StackResourceSummaries": [
        {
            "ResourceType": "AWS::EC2::Instance", 
            "LastUpdatedTimestamp": "2022-04-02T11:53:01.751Z", 
            "ResourceStatus": "DELETE_COMPLETE", 
            "DriftInformation": {
                "StackResourceDriftStatus": "NOT_CHECKED"
            }, 
            "LogicalResourceId": "WebServer"
        }
    ]
}
ec2-user:~/environment/LearningEB/cfn-project (main) $ aws cloudformation describe-stacks --stack-name StudySync --output table
------------------------------------------------------------------------------------------------------------------------------------------
|                                                             DescribeStacks                                                             |
+----------------------------------------------------------------------------------------------------------------------------------------+
||                                                                Stacks                                                                ||
|+-----------------------------+--------------------------------------------------------------------------------------------------------+|
||  CreationTime               |  2022-04-02T11:52:53.634Z                                                                              ||
||  DeletionTime               |  2022-04-02T11:52:58.075Z                                                                              ||
||  Description                |  Infrastructure for StudySync                                                                          ||
||  DisableRollback            |  False                                                                                                 ||
||  EnableTerminationProtection|  False                                                                                                 ||
||  StackId                    |  arn:aws:cloudformation:ap-south-1:731417425637:stack/StudySync/6cf0e190-b27b-11ec-8a77-06abc5600c42   ||
||  StackName                  |  StudySync                                                                                             ||
||  StackStatus                |  ROLLBACK_COMPLETE                                                                                     ||
|+-----------------------------+--------------------------------------------------------------------------------------------------------+|
|||                                                          DriftInformation                                                          |||
||+---------------------------------------------------------------------------+--------------------------------------------------------+||
|||  StackDriftStatus                                                         |  NOT_CHECKED                                           |||
||+---------------------------------------------------------------------------+--------------------------------------------------------+||
|||                                                        RollbackConfiguration                                                       |||
||+------------------------------------------------------------------------------------------------------------------------------------+||
ec2-user:~/environment/LearningEB/cfn-project (main) $ aws cloudformation list-stack-resources --stack-name StudySync
{
    "StackResourceSummaries": [
        {
            "ResourceType": "AWS::EC2::Instance", 
            "LastUpdatedTimestamp": "2022-04-02T11:53:01.751Z", 
            "ResourceStatus": "DELETE_COMPLETE", 
            "DriftInformation": {
                "StackResourceDriftStatus": "NOT_CHECKED"
            }, 
            "LogicalResourceId": "WebServer"
        }
    ]
}
ec2-user:~/environment/LearningEB/cfn-project (main) $ aws cloudformation list-stack-resources --stack-name StudySync
{
    "StackResourceSummaries": [
        {
            "ResourceType": "AWS::EC2::Instance", 
            "LastUpdatedTimestamp": "2022-04-02T11:53:01.751Z", 
            "ResourceStatus": "DELETE_COMPLETE", 
            "DriftInformation": {
                "StackResourceDriftStatus": "NOT_CHECKED"
            }, 
            "LogicalResourceId": "WebServer"
        }
    ]
}
ec2-user:~/environment/LearningEB/cfn-project (main) $ cfn-lint validate template.yaml 
0 infos
0 warn
0 crit
Template valid!
ec2-user:~/environment/LearningEB/cfn-project (main) $ ./update.sh 
upload: ./template.yaml to s3://studysync-cfn/template.yaml         

An error occurred (ValidationError) when calling the UpdateStack operation: No updates are to be performed.
ec2-user:~/environment/LearningEB/cfn-project (main) $ ./update.sh 
upload: ./template.yaml to s3://studysync-cfn/template.yaml   

An error occurred (ValidationError) when calling the UpdateStack operation: Template format error: YAML not well-formed. (line 23, column 21)
ec2-user:~/environment/LearningEB/cfn-project (main) $ ./update.sh 
upload: ./template.yaml to s3://studysync-cfn/template.yaml   

An error occurred (ValidationError) when calling the UpdateStack operation: [/Outputs/PublicIp] 'null' values are not allowed in templates
ec2-user:~/environment/LearningEB/cfn-project (main) $ ./update.sh 
upload: ./template.yaml to s3://studysync-cfn/template.yaml   
{
    "StackId": "arn:aws:cloudformation:us-east-1:731417425637:stack/StudySync/b746ba30-b27b-11ec-824e-0a15535d307b"
}
ec2-user:~/environment/LearningEB/cfn-project (main) $ ./create.sh 
upload: ./template.yaml to s3://studysync-cfn/template.yaml   
{
    "StackId": "arn:aws:cloudformation:us-east-1:731417425637:stack/StudySync/9e3c9ae0-b281-11ec-ba4b-0e8c7fb8df65"
}
ec2-user:~/environment/LearningEB/cfn-project (main) $ chmod u+x delete.sh 
ec2-user:~/environment/LearningEB/cfn-project (main) $ ./delete.sh 
upload: ./template.yaml to s3://studysync-cfn/template.yaml   
ec2-user:~/environment/LearningEB/cfn-project (main) $ ./create.sh 
upload: ./template.yaml to s3://studysync-cfn/template.yaml   
{
    "StackId": "arn:aws:cloudformation:us-east-1:731417425637:stack/StudySync/fa191350-b283-11ec-8153-12206030b563"
}
ec2-user:~/environment/LearningEB/cfn-project (main) $ 