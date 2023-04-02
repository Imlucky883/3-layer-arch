# 3-Layered Architecture using Terraform on AWS

![main](https://miro.medium.com/v2/resize:fit:720/format:webp/1*CVwRuH9TUTB4_tv8K_54UQ.png)


A 3-layered architecture, also known as a three-tier architecture, is a client-server architecture that separates an application into three distinct layers: presentation layer, application layer, and data layer. Each layer serves a specific purpose and can be scaled and managed independently, providing high availability, fault tolerance, and scalability.

**Presentation layer**: This layer is responsible for presenting the user interface to the user. It includes components such as web servers and load balancers that receive and process user requests.

**Application layer**: This layer is responsible for processing user requests and generating responses. It includes components such as application servers and databases that provide the logic and data for the application.

**Data layer**: This layer is responsible for storing and retrieving data used by the application. It includes components such as databases that store and manage the application's data.

## Why is a 3-layered architecture important in Cloud?
A 3-layered architecture is important in Cloud because it provides several benefits that are crucial for modern applications:

**High availability**: By separating an application into different layers, each layer can be scaled and managed independently, ensuring that the application is always available and responsive to user requests.

**Fault tolerance:** In case of a failure in one layer, the other layers can continue to operate without disruption, minimizing the impact on the application.

**Scalability**: Each layer can be scaled horizontally or vertically independently, allowing the application to handle increased traffic and workload without affecting other layers.

## Clone the Project
```
git clone git@github.com:Imlucky883/3-layer-architecture.git
```

## Directory Structure

![Imgur](https://i.imgur.com/eAootkq.png)

## Getting Started

### Web Tier

+ 2 public subnets
+ Minimum of 2 EC2 instances with an OS of your choice (free tier) in an Auto Scaling Group.
+ EC2 Web Server Security Group allowing inbound permission from the internet.
+ Boot strap static web page or create a custom AMI that already includes the static web page.
+ Create a public route table and associate the 2 public subnets.

### Application Tier

+ 2 private subnets
+ Minimum of 2 EC2 instances with an OS of your choice (free tier) in an Auto Scaling Group.
+ EC2 Application Server Security Group allowing inbound permission from the Web Server Security Group.
+ Associate with private route table.

`Note: This is not a true application tier as we don’t have any provided code to run on the EC2 instances.`

### Database Tier

+ Use a free Tier MySql RDS Database.
+ The Database Security Group should allow inbound traffic for MySQL from the Application Server Security Group.
+ 2 private subnets.
+ Associate with private route table.

`Note: No need to use Multi-AZ but be sure to document how you would add it`

### Accessing the private instance using SSM Manager

**Prerequesits**

+ Credentials to be set using `aws configure ` or in `~/.aws/credentials` file
+ AWS CLI version >=2 
+ SSM Manager Plugin on the host machine


1. To create an IAM Role for Systems Manager managed instances (console)
![image](https://docs.aws.amazon.com/images/systems-manager/latest/userguide/images/setup-instance-profile-2.png)
2. Attach the IAM role to your instance. You can do this by selecting your instance in the AWS Management Console, choosing "Actions", and then "Instance Settings", followed by "Attach/Replace IAM Role"
3. Open the System Manager in the AWS Management Console. Navigate to `Setup Inventory > Targets > Manually Selecting Instances > IAM role name`.  
4. Select the instance ID of the instance that you want to login into.

```
aws ssm start-session --target *instace_ID*
```
5. You should be successfully logined to the private instance.
6. To connect to the database, get the hostname of the db instance from the console
   + ``` yum install mysql```
   + ``` mysql -h hostname -P 3306 -u username -p ```
7. You should see output something like below :

![Imgur](https://i.imgur.com/BKrRcHe.png)

References : https://aws.plainenglish.io/creation-of-a-highly-available-3-tier-architecture-30b2be0a871e 
