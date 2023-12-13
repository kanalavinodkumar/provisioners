#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOG=/tmp/workstation.log
# USER_ID=$(id -u)
# if [ $USER_ID -ne 0 ]; then
# 	echo  -e "$R You are not the root user, you dont have permissions to run this $N"
# 	exit 1
# fi

VALIDATE(){
	if [ $1 -ne 0 ]; then
		echo -e "$2 ... $R FAILED $N"
		exit 1
	else
		echo -e "$2 ... $G SUCCESS $N"
	fi

}

sudo yum update  -y &>>$LOG
VALIDATE $? "Updating packages"

sudo amazon-linux-extras install docker -y &>>$LOG
VALIDATE $? "Installing Docker"

sudo service docker start &>>$LOG
VALIDATE $? "Starting Docker"

sudo systemctl enable docker &>>$LOG
VALIDATE $? "Enabling Docker"

sudo usermod -a -G docker ec2-user &>>$LOG
VALIDATE $? "Added ec2-user to docker group"

sudo yum install git -y &>>$LOG
VALIDATE $? "Installing GIT"

sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose &>>$LOG
VALIDATE $? "Downloaded docker-compose"

sudo chmod +x /usr/local/bin/docker-compose
VALIDATE $? "Moved docker-compose to local bin"

echo  -e "$R You need logout and login to the server $N"

sudo curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.27.1/2023-04-19/bin/linux/amd64/kubectl &>>$LOG
VALIDATE $? "Downloaded kubectl"

sudo chmod +x ./kubectl

sudo mv ./kubectl /usr/local/bin/
VALIDATE $? "Moved kubectl to local bin"