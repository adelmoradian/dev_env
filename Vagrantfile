Vagrant.configure('2') do |config|

  config.vm.box = 'ilionx/ubuntu2004-minikube'
  config.vm.hostname = 'local.dev'
  config.vm.network 'private_network', ip: '10.0.0.10'
  config.vm.provider 'virtualbox' do |vb|
    vb.memory = 6144
    vb.cpus = 4
  end
	config.vm.synced_folder "./", "/vagrant"
	config.vm.provision "ansible" do |ansible|
	  ansible.playbook = "setup.yaml"
	end
 end
