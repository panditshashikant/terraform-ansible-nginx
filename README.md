This project is to automate the system on ubuntu: to install nginx, wordpress, mysq, php  

Steps to setup the project: -

1. sudo apt update -y
2. sudo apt install ansible -y
3. $ ssh-keygen # hit 3 times 
4. $ cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
5. $ git clone https://github.com/panditshashikant/ansible-nginx.git
6. $ cd /home/ubuntu/ansible-nginx
7. $ vi hosts # change [webservers] host
8. $ ansible-playbook -i hosts playbook.yml -u ubuntu

Once you setup and run successfully.
Open your host which you have passed in hosts (inventory file) in browser
You can login and see the result looks like: -
![image](https://user-images.githubusercontent.com/19287588/183235758-04e146c2-f32c-450b-acf9-1dc15dbe690e.png)
