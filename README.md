# Deploy-HA-Application-and-db
Deploy an application (with high availability) with a database-Using Terraform and Ansible
Provide database credentials to the application through automation
 Deploy a second instance of the application, pointing to the same database
Add a load balancer or reverse proxy to load-balance requests across the two instances
Store the database credentials in an encrypted form using Ansible Vault
Add a cron job which takes backups of the database
Deploy a separate, single instance of the application to a ‘dev’ or ‘test’ environment