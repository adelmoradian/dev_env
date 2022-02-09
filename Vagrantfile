Vagrant.configure('2') do |config|

	config.vm.synced_folder "../", "/vagrant"
  config.vm.box = 'ilionx/ubuntu2004-minikube'
  config.vm.network 'private_network', ip: '10.0.0.10'
  config.vm.provision "ansible" do |ansible|
  config.vm.provider 'virtualbox' do |vb|
    vb.name = 'dev'
    vb.memory = 4096
    vb.cpus = 2
  end
    ansible.playbook = "playbook.yml"
  end

 end
