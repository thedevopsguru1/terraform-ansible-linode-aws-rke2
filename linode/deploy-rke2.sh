terraform init 
terraform apply --auto-approve

echo "Sleeping for 120 seconds!!....."
sleep 120
bash create_inventory.sh
ANSIBLE_HOST_KEY_CHECKING=False ansible -b -i ansible/inventory all -m ping 

ansible-playbook -b -i ansible/inventory ansible/rke2.yml

