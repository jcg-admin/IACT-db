# -*- mode: ruby -*-
# vi: set ft=ruby :

# =============================================================================
# IACT DevBox - Vagrant Configuration (Multi-Machine)
# MariaDB 11.4 LTS + PostgreSQL 16 + Adminer 4.8.1 Development Environment
# =============================================================================
# Architecture: 3 separate VMs with Host-Only networking
#   - MariaDB VM:    192.168.56.10:3306
#   - PostgreSQL VM: 192.168.56.11:5432
#   - Adminer VM:    192.168.56.12:80/443
# =============================================================================

VAGRANTFILE_API_VERSION = "2"

# =============================================================================
# COLOR CODES FOR TERMINAL OUTPUT
# =============================================================================
red = "\033[0;31m"
green = "\033[0;32m"
yellow = "\033[0;33m"
blue = "\033[0;34m"
creset = "\033[0m"

# Directory paths
vagrant_dir = File.expand_path(File.dirname(__FILE__))

# =============================================================================
# PLUGIN AUTO-INSTALLATION (vagrant-goodhosts for adminer.devbox domain)
# =============================================================================

unless Vagrant.has_plugin?('vagrant-goodhosts')
  puts ""
  puts "#{yellow}╔═══════════════════════════════════════════════════════════════════╗#{creset}"
  puts "#{yellow}║  Installing required plugin: vagrant-goodhosts                   ║#{creset}"
  puts "#{yellow}╚═══════════════════════════════════════════════════════════════════╝#{creset}"
  puts ""
  puts "#{blue}This plugin automatically manages your hosts file for adminer.devbox#{creset}"
  puts ""

  # Check if local gem file exists (for offline installation)
  if File.file?(File.join(vagrant_dir, 'vagrant-goodhosts.gem'))
    puts "#{blue}Installing from local gem file...#{creset}"
    system('vagrant plugin install ' + File.join(vagrant_dir, 'vagrant-goodhosts.gem'))
    File.delete(File.join(vagrant_dir, 'vagrant-goodhosts.gem'))
    puts ""
    puts "#{green}✓ vagrant-goodhosts plugin installed from local gem#{creset}"
    puts "#{yellow}Please run 'vagrant up' again to continue.#{creset}"
    puts ""
    exit
  else
    # Install from RubyGems
    puts "#{blue}Installing from RubyGems...#{creset}"
    unless system('vagrant plugin install vagrant-goodhosts')
      puts ""
      puts "#{red}✗ Failed to install vagrant-goodhosts plugin#{creset}"
      puts "#{yellow}You can install it manually with: vagrant plugin install vagrant-goodhosts#{creset}"
      puts ""
      exit 1
    end
    puts ""
    puts "#{green}✓ vagrant-goodhosts plugin installed successfully#{creset}"
    puts "#{yellow}Please run 'vagrant up' again to continue.#{creset}"
    puts ""
    exit
  end
end

# Disable vbguest auto-update if plugin is installed (causes issues for some users)
if Vagrant.has_plugin?('vagrant-vbguest')
  puts "#{blue}ℹ vagrant-vbguest detected - auto_update will be disabled#{creset}"
end

puts "#{green}✓ All required plugins are installed#{creset}"
puts ""

# =============================================================================
# CONFIGURATION VARIABLES - SINGLE SOURCE OF TRUTH
# =============================================================================

# Network Configuration - Host-Only Network
MARIADB_IP = "192.168.56.10"
POSTGRES_IP = "192.168.56.11"
ADMINER_IP = "192.168.56.12"

# Adminer Domain (.devbox TLD for IACT DevBox)
ADMINER_DOMAIN = "adminer.devbox"

# Database Ports
MARIADB_PORT = "3306"
POSTGRES_PORT = "5432"
ADMINER_HTTP_PORT = "80"
ADMINER_HTTPS_PORT = "443"

# MariaDB Configuration
MARIADB_VERSION = "11.4"
DB_MARIADB_NAME = "ivr_legacy"
DB_MARIADB_USER = "django_user"
DB_MARIADB_PASSWORD = "django_pass"
DB_MARIADB_ROOT_PASSWORD = "rootpass123"
DB_CHARSET = "utf8mb4"
DB_COLLATION = "utf8mb4_unicode_ci"

# PostgreSQL Configuration
POSTGRES_VERSION = "16"
DB_POSTGRES_NAME = "iact_analytics"
DB_POSTGRES_USER = "django_user"
DB_POSTGRES_PASSWORD = "django_pass"
POSTGRES_PASSWORD = "postgrespass123"

# Adminer Configuration
ADMINER_VERSION = "4.8.1"
SWAP_SIZE = "1G"

# SSL Configuration
SSL_DAYS = "365"
SSL_COUNTRY = "MX"
SSL_STATE = "Estado"
SSL_CITY = "Ciudad"
SSL_ORG = "IACT DevBox"
SSL_OU = "Development"
SSL_CN = ADMINER_DOMAIN

# =============================================================================
# HELPER FUNCTIONS
# =============================================================================


# =============================================================================
# DISPLAY CONFIGURATION SUMMARY
# =============================================================================

puts "=" * 70
puts "  IACT DevBox Multi-Machine Configuration"
puts "=" * 70
puts ""
puts "Architecture: 3 VMs with Host-Only Network (192.168.56.0/24)"
puts ""
puts "VM 1 - MariaDB:"
puts "  Name:      iact-mariadb"
puts "  IP:        #{MARIADB_IP}:#{MARIADB_PORT}"
puts "  Version:   MariaDB #{MARIADB_VERSION}"
puts "  Database:  #{DB_MARIADB_NAME}"
puts "  Memory:    2048 MB"
puts "  CPUs:      1"
puts ""
puts "VM 2 - PostgreSQL:"
puts "  Name:      iact-postgres"
puts "  IP:        #{POSTGRES_IP}:#{POSTGRES_PORT}"
puts "  Version:   PostgreSQL #{POSTGRES_VERSION}"
puts "  Database:  #{DB_POSTGRES_NAME}"
puts "  Memory:    2048 MB"
puts "  CPUs:      1"
puts ""
puts "VM 3 - Adminer:"
puts "  Name:      iact-adminer"
puts "  IP:        #{ADMINER_IP}:#{ADMINER_HTTP_PORT}/#{ADMINER_HTTPS_PORT}"
puts "  Domain:    #{ADMINER_DOMAIN}"
puts "  URLs:      http://#{ADMINER_DOMAIN}"
puts "             https://#{ADMINER_DOMAIN}"
puts "  Version:   Adminer #{ADMINER_VERSION}"
puts "  Memory:    1024 MB"
puts "  CPUs:      1"
puts ""
puts "Commands:"
puts "  Start all:    vagrant up"
puts "  Start one:    vagrant up mariadb|postgresql|adminer"
puts "  SSH:          vagrant ssh mariadb|postgresql|adminer"
puts "  Stop all:     vagrant halt"
puts "  Destroy all:  vagrant destroy"
puts "=" * 70
puts ""

# =============================================================================
# APT CACHE OPTIMIZATION
# =============================================================================

def local_cache(box_name)
  begin
    cache_dir = File.join(File.expand_path('~/.vagrant.d'), 'cache', 'apt', box_name)
    FileUtils.mkdir_p(cache_dir) unless File.exist?(cache_dir)
    return cache_dir if File.writable?(cache_dir)
  rescue => e
    puts "WARNING: APT cache disabled: #{e.message}"
  end
  nil
end

# =============================================================================
# VAGRANT MULTI-MACHINE CONFIGURATION
# =============================================================================

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # ===========================================================================
  # GLOBAL TRIGGERS - Execute before/after vagrant commands
  # ===========================================================================

  # Trigger: Before 'vagrant up' - Check Host-Only network status
  config.trigger.before :up do |trigger|
    trigger.name = "Network Setup Check"
    trigger.info = "Checking Host-Only network configuration..."

    trigger.ruby do |env, machine|
      puts ""
      puts "=" * 70
      puts "   NETWORK CONFIGURATION CHECK"
      puts "=" * 70
      puts ""

      # Verificar si existen interfaces Host-Only
      begin
        if Vagrant::Util::Platform.windows?
          result = `VBoxManage list hostonlyifs 2>NUL`
        else
          result = `VBoxManage list hostonlyifs 2>/dev/null`
        end
      rescue => e
        result = ""
      end

      if result.nil? || result.empty?
        # Solo avisamos, Vagrant creará la red automáticamente al detectar
        # la configuración "private_network" en las VMs.
        puts "[INFO] No Host-Only network detected. Vagrant will create one."
      else
        puts "[OK] Host-Only network environment is ready."
        puts "     Vagrant will auto-assign the IPs to the correct adapter."
      end

      puts ""
      puts "=" * 70
      puts ""
    end
  end

  # Trigger: After successful 'vagrant up'
  config.trigger.after :up do |trigger|
    trigger.name = "Post-Up Summary"
    trigger.info = "VMs are ready!"
    trigger.only_on = "adminer"  # Only show once (after last VM)

    trigger.ruby do |env, machine|
      puts ""
      puts "=" * 70
      puts "  [OK] ALL VMs READY"
      puts "=" * 70
      puts ""
      puts "Quick Test:"
      puts "  ping #{MARIADB_IP}"
      puts "  ping #{POSTGRES_IP}"
      puts "  ping #{ADMINER_IP}"
      puts ""
      puts "Connect:"
      puts "  mysql -h #{MARIADB_IP} -u root -p'#{DB_MARIADB_ROOT_PASSWORD}'"
      puts "  psql -h #{POSTGRES_IP} -U postgres"
      puts "  http://#{ADMINER_IP}"
      puts ""
      puts "Logs:"
      puts "  ./logs/"
      puts ""
      puts "=" * 70
      puts ""
    end
  end

  # Trigger: After successful 'vagrant up'
  config.trigger.after :up do |trigger|
    trigger.name = "Post-Up Summary"
    trigger.info = "VMs are ready!"
    trigger.only_on = "adminer"  # Only show once (after last VM)

    trigger.ruby do |env, machine|
      puts ""
      puts "=" * 70
      puts "  [OK] ALL VMs READY"
      puts "=" * 70
      puts ""
      puts "Quick Test:"
      puts "  ping #{MARIADB_IP}"
      puts "  ping #{POSTGRES_IP}"
      puts "  ping #{ADMINER_IP}"
      puts ""
      puts "Connect:"
      puts "  mysql -h #{MARIADB_IP} -u root -p'#{DB_MARIADB_ROOT_PASSWORD}'"
      puts "  psql -h #{POSTGRES_IP} -U postgres"
      puts "  http://#{ADMINER_IP}"
      puts ""
      puts "Logs:"
      puts "  ./logs/"
      puts ""
      puts "=" * 70
      puts ""
    end
  end

  # ===========================================================================
  # VM 1: MARIADB (192.168.56.10)
  # ===========================================================================

  config.vm.define "mariadb", primary: true do |mariadb|
    # Base box
    mariadb.vm.box = "ubuntu/focal64"
    mariadb.vm.box_check_update = true

    # Hostname
    mariadb.vm.hostname = "iact-mariadb"

    # Disable vbguest auto-update if plugin is installed
    if Vagrant.has_plugin?("vagrant-vbguest")
      mariadb.vbguest.auto_update = false
    end

    # SSH configuration
    mariadb.ssh.forward_agent = true
    mariadb.ssh.insert_key = true
    mariadb.ssh.connect_timeout = 120

    # -----------------------------------------------------------------------
    # Network - Host-Only with static IP (FORMA ESTÁNDAR)
    # -----------------------------------------------------------------------
    # Al eliminar el parámetro 'name', evitamos conflictos de adaptadores duplicados.
    mariadb.vm.network "private_network", ip: MARIADB_IP, netmask: "255.255.255.0"
    # SSH Port Forwarding
    mariadb.vm.network "forwarded_port", guest: 22, host: 2222, id: "ssh", auto_correct: true


    # Synced folders
    cache_dir = local_cache(mariadb.vm.box)
    if cache_dir
      mariadb.vm.synced_folder cache_dir, "/var/cache/apt/archives/",
        create: true,
        mount_options: ["dmode=755,fmode=644"]
    end

    mariadb.vm.synced_folder ".", "/vagrant",
      create: true,
      mount_options: [
        "dmode=755,fmode=644",
        "iocharset=utf8",
        "ttl=1"
      ]

    # VirtualBox provider configuration for MariaDB
    mariadb.vm.provider "virtualbox" do |vb|
      vb.name = "iact-mariadb"
      vb.memory = 2048
      vb.cpus = 1
      vb.gui = false
      vb.linked_clone = true

      # Performance optimizations
      vb.customize ["modifyvm", :id, "--ioapic", "on"]
      vb.customize ["modifyvm", :id, "--vram", "12"]
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
      vb.customize ["modifyvm", :id, "--audio", "none"]
      vb.customize ["modifyvm", :id, "--usb", "off"]
      vb.customize ["modifyvm", :id, "--usbehci", "off"]
      vb.customize ["modifyvm", :id, "--rtcuseutc", "on"]

      # Red y Conectividad (Crucial para VirtualBox 7.x)
      vb.customize ["modifyvm", :id, "--cableconnected1", "on"]
      vb.customize ["modifyvm", :id, "--cableconnected2", "on"]
      vb.customize ["modifyvm", :id, "--nictype2", "virtio"]
    end

    # Provisioning - MariaDB VM
    mariadb.vm.provision "shell", inline: <<-SHELL
      set -euo pipefail

      echo ""
      echo "=================================================="
      echo "  MariaDB VM Provisioning"
      echo "=================================================="
      echo ""

      # Export ALL configuration variables
      export MARIADB_VERSION="#{MARIADB_VERSION}"
      export DB_NAME="#{DB_MARIADB_NAME}"
      export DB_CHARSET="#{DB_CHARSET}"
      export DB_COLLATION="#{DB_COLLATION}"
      export DB_USER="#{DB_MARIADB_USER}"
      export DB_PASSWORD="#{DB_MARIADB_PASSWORD}"
      export DB_ROOT_PASSWORD="#{DB_MARIADB_ROOT_PASSWORD}"
      export MARIADB_IP="#{MARIADB_IP}"
      export MARIADB_PORT="#{MARIADB_PORT}"

      # Create logs directory
      mkdir -p /vagrant/logs

      # Make scripts executable
      find /vagrant/provisioners -name "*.sh" -exec chmod +x {} \\;
      find /vagrant/utils -name "*.sh" -exec chmod +x {} \\;

      echo "[OK] Scripts prepared"
      echo ""

      # Execute bootstrap script
      cd /vagrant

      echo "Executing MariaDB bootstrap..."
      if bash provisioners/mariadb/bootstrap.sh; then
        echo "[OK] MariaDB provisioning completed"
      else
        echo "[ERROR] MariaDB provisioning failed"
        exit 1
      fi

      echo ""
      echo "=================================================="
      echo "  [OK] MariaDB VM Ready"
      echo "=================================================="
      echo ""
      echo "MariaDB accessible at: #{MARIADB_IP}:#{MARIADB_PORT}"
      echo "  Database: #{DB_MARIADB_NAME}"
      echo "  User:     #{DB_MARIADB_USER}"
      echo ""
    SHELL
  end

  # ===========================================================================
  # VM 2: POSTGRESQL (192.168.56.11)
  # ===========================================================================

  config.vm.define "postgresql" do |postgresql|
    # Base box
    postgresql.vm.box = "ubuntu/focal64"
    postgresql.vm.box_check_update = true

    # Hostname
    postgresql.vm.hostname = "iact-postgres"

    # Disable vbguest auto-update if plugin is installed
    if Vagrant.has_plugin?("vagrant-vbguest")
      postgresql.vbguest.auto_update = false
    end

    # SSH configuration
    postgresql.ssh.forward_agent = true
    postgresql.ssh.insert_key = true
    postgresql.ssh.connect_timeout = 120

    # -----------------------------------------------------------------------
    # Network - Host-Only with static IP (FORMA ESTÁNDAR)
    # -----------------------------------------------------------------------
    # Simplificado para evitar conflictos de nombres de adaptadores
    postgresql.vm.network "private_network", ip: POSTGRES_IP, netmask: "255.255.255.0"
    # SSH Port Forwarding
    postgresql.vm.network "forwarded_port", guest: 22, host: 2200, id: "ssh", auto_correct: true


    # Synced folders
    cache_dir = local_cache(postgresql.vm.box)
    if cache_dir
      postgresql.vm.synced_folder cache_dir, "/var/cache/apt/archives/",
        create: true,
        mount_options: ["dmode=755,fmode=644"]
    end

    postgresql.vm.synced_folder ".", "/vagrant",
      create: true,
      mount_options: [
        "dmode=755,fmode=644",
        "iocharset=utf8",
        "ttl=1"
      ]

    # VirtualBox provider configuration for PostgreSQL
    postgresql.vm.provider "virtualbox" do |vb|
      vb.name = "iact-postgres"
      vb.memory = 2048
      vb.cpus = 1
      vb.gui = false
      vb.linked_clone = true

      # Performance optimizations
      vb.customize ["modifyvm", :id, "--ioapic", "on"]
      vb.customize ["modifyvm", :id, "--vram", "12"]
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
      vb.customize ["modifyvm", :id, "--audio", "none"]
      vb.customize ["modifyvm", :id, "--usb", "off"]
      vb.customize ["modifyvm", :id, "--usbehci", "off"]
      vb.customize ["modifyvm", :id, "--rtcuseutc", "on"]

      # Red y Conectividad (Cambiado de 82540EM a virtio y añadido cableconnected2)
      vb.customize ["modifyvm", :id, "--cableconnected1", "on"]
      vb.customize ["modifyvm", :id, "--cableconnected2", "on"]
      vb.customize ["modifyvm", :id, "--nictype2", "virtio"]
    end

    # Provisioning - PostgreSQL VM
    postgresql.vm.provision "shell", inline: <<-SHELL
      set -euo pipefail

      echo ""
      echo "=================================================="
      echo "  PostgreSQL VM Provisioning"
      echo "=================================================="
      echo ""

      # Export ALL configuration variables
      export POSTGRES_VERSION="#{POSTGRES_VERSION}"
      export DB_NAME="#{DB_POSTGRES_NAME}"
      export DB_USER="#{DB_POSTGRES_USER}"
      export DB_PASSWORD="#{DB_POSTGRES_PASSWORD}"
      export POSTGRES_PASSWORD="#{POSTGRES_PASSWORD}"
      export POSTGRES_IP="#{POSTGRES_IP}"
      export POSTGRES_PORT="#{POSTGRES_PORT}"

      # Create logs directory
      mkdir -p /vagrant/logs

      # Make scripts executable
      find /vagrant/provisioners -name "*.sh" -exec chmod +x {} \\;
      find /vagrant/utils -name "*.sh" -exec chmod +x {} \\;

      echo "[OK] Scripts prepared"
      echo ""

      # Execute bootstrap script
      cd /vagrant

      echo "Executing PostgreSQL bootstrap..."
      if bash provisioners/postgres/bootstrap.sh; then
        echo "[OK] PostgreSQL provisioning completed"
      else
        echo "[ERROR] PostgreSQL provisioning failed"
        exit 1
      fi

      echo ""
      echo "=================================================="
      echo "  [OK] PostgreSQL VM Ready"
      echo "=================================================="
      echo ""
      echo "PostgreSQL accessible at: #{POSTGRES_IP}:#{POSTGRES_PORT}"
      echo "  Database: #{DB_POSTGRES_NAME}"
      echo "  User:     #{DB_POSTGRES_USER}"
      echo ""
    SHELL
  end

  # ===========================================================================
  # VM 3: ADMINER (192.168.56.12)
  # ===========================================================================

  config.vm.define "adminer" do |adminer|
    # Base box
    adminer.vm.box = "ubuntu/focal64"
    adminer.vm.box_check_update = true

    # Hostname
    adminer.vm.hostname = ADMINER_DOMAIN

    # Disable vbguest auto-update if plugin is installed
    if Vagrant.has_plugin?("vagrant-vbguest")
      adminer.vbguest.auto_update = false
    end

    # SSH configuration
    adminer.ssh.forward_agent = true
    adminer.ssh.insert_key = true
    adminer.ssh.connect_timeout = 120
    # SSH Port Forwarding
    adminer.vm.network "forwarded_port", guest: 22, host: 2201, id: "ssh", auto_correct: true

    # -------------------------------------------------------------------------
    # vagrant-goodhosts - Automatic hosts file management for adminer.devbox
    # -------------------------------------------------------------------------
    if Vagrant.has_plugin?('vagrant-goodhosts')
      adminer.goodhosts.aliases = [
        ADMINER_DOMAIN,           # adminer.devbox
        "www.#{ADMINER_DOMAIN}"   # www.adminer.devbox
      ]
    end

    # -----------------------------------------------------------------------
    # Network - Host-Only with static IP (FORMA ESTÁNDAR)
    # -----------------------------------------------------------------------
    # Eliminamos la dependencia de 'adapter_name' para evitar el error de timeout
    adminer.vm.network "private_network", ip: ADMINER_IP, netmask: "255.255.255.0"

    # Synced folders
    cache_dir = local_cache(adminer.vm.box)
    if cache_dir
      adminer.vm.synced_folder cache_dir, "/var/cache/apt/archives/",
        create: true,
        mount_options: ["dmode=755,fmode=644"]
    end

    adminer.vm.synced_folder ".", "/vagrant",
      create: true,
      mount_options: [
        "dmode=755,fmode=644",
        "iocharset=utf8",
        "ttl=1"
      ]

    # VirtualBox provider configuration for Adminer
    adminer.vm.provider "virtualbox" do |vb|
      vb.name = "iact-adminer"
      vb.memory = 1024
      vb.cpus = 1
      vb.gui = false
      vb.linked_clone = true

      # Performance optimizations
      vb.customize ["modifyvm", :id, "--ioapic", "on"]
      vb.customize ["modifyvm", :id, "--vram", "12"]
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
      vb.customize ["modifyvm", :id, "--audio", "none"]
      vb.customize ["modifyvm", :id, "--usb", "off"]
      vb.customize ["modifyvm", :id, "--usbehci", "off"]
      vb.customize ["modifyvm", :id, "--rtcuseutc", "on"]

      # Red y Conectividad (Cambiado de 82540EM a virtio y añadido cableconnected2)
      vb.customize ["modifyvm", :id, "--cableconnected1", "on"]
      vb.customize ["modifyvm", :id, "--cableconnected2", "on"]
      vb.customize ["modifyvm", :id, "--nictype2", "virtio"]
    end

    # Provisioning - Adminer VM
    adminer.vm.provision "shell", inline: <<-SHELL
      set -euo pipefail

      echo ""
      echo "=================================================="
      echo "  Adminer VM Provisioning"
      echo "=================================================="
      echo ""

      # Export ALL configuration variables
      export ADMINER_VERSION="#{ADMINER_VERSION}"
      export ADMINER_IP="#{ADMINER_IP}"
      export ADMINER_HTTP_PORT="#{ADMINER_HTTP_PORT}"
      export ADMINER_HTTPS_PORT="#{ADMINER_HTTPS_PORT}"
      export SWAP_SIZE="#{SWAP_SIZE}"
      export MARIADB_IP="#{MARIADB_IP}"
      export POSTGRES_IP="#{POSTGRES_IP}"

      # SSL Configuration
      export SSL_DAYS="#{SSL_DAYS}"
      export SSL_COUNTRY="#{SSL_COUNTRY}"
      export SSL_STATE="#{SSL_STATE}"
      export SSL_CITY="#{SSL_CITY}"
      export SSL_ORG="#{SSL_ORG}"
      export SSL_OU="#{SSL_OU}"
      export SSL_CN="#{SSL_CN}"

      # Create logs directory
      mkdir -p /vagrant/logs

      # Make scripts executable
      find /vagrant/provisioners -name "*.sh" -exec chmod +x {} \\;
      find /vagrant/utils -name "*.sh" -exec chmod +x {} \\;

      echo "[OK] Scripts prepared"
      echo ""

      # Execute bootstrap script
      cd /vagrant

      echo "Executing Adminer bootstrap..."
      if bash provisioners/adminer/bootstrap.sh; then
        echo "[OK] Adminer provisioning completed"
      else
        echo "[ERROR] Adminer provisioning failed"
        exit 1
      fi

      echo ""
      echo "=================================================="
      echo "  [OK] Adminer VM Ready"
      echo "=================================================="
      echo ""
      echo "Adminer accessible at:"
      echo "  HTTP:  http://#{ADMINER_IP}"
      echo "  HTTPS: https://#{ADMINER_IP}"
      echo ""
      echo "Connects to:"
      echo "  MariaDB:    #{MARIADB_IP}:#{MARIADB_PORT}"
      echo "  PostgreSQL: #{POSTGRES_IP}:#{POSTGRES_PORT}"
      echo ""
    SHELL
  end

  # ===========================================================================
  # POST-UP MESSAGE
  # ===========================================================================

  config.vm.post_up_message = <<-MESSAGE

  ========================================================================
                     IACT DevBox Multi-Machine Ready!
  ========================================================================

  ARCHITECTURE: 3 VMs with Host-Only Network (192.168.56.0/24)

  VM 1 - MARIADB:
    IP:        #{MARIADB_IP}
    Port:      #{MARIADB_PORT}
    Database:  #{DB_MARIADB_NAME}
    User:      #{DB_MARIADB_USER}
    Password:  #{DB_MARIADB_PASSWORD}
    SSH:       vagrant ssh mariadb

  VM 2 - POSTGRESQL:
    IP:        #{POSTGRES_IP}
    Port:      #{POSTGRES_PORT}
    Database:  #{DB_POSTGRES_NAME}
    User:      #{DB_POSTGRES_USER}
    Password:  #{DB_POSTGRES_PASSWORD}
    SSH:       vagrant ssh postgresql

  VM 3 - ADMINER:
    IP:        #{ADMINER_IP}
    HTTP:      http://#{ADMINER_IP}
    HTTPS:     https://#{ADMINER_IP}
    SSH:       vagrant ssh adminer

  CONNECTION FROM HOST:

    MariaDB:
      mysql -h #{MARIADB_IP} -u root -p'#{DB_MARIADB_ROOT_PASSWORD}'
      mysql -h #{MARIADB_IP} -u #{DB_MARIADB_USER} -p'#{DB_MARIADB_PASSWORD}' #{DB_MARIADB_NAME}

    PostgreSQL:
      PGPASSWORD='#{POSTGRES_PASSWORD}' psql -h #{POSTGRES_IP} -U postgres
      PGPASSWORD='#{DB_POSTGRES_PASSWORD}' psql -h #{POSTGRES_IP} -U #{DB_POSTGRES_USER} -d #{DB_POSTGRES_NAME}

    Adminer:
      Open in browser: http://#{ADMINER_IP}

  DJANGO SETTINGS:

    DATABASES = {
        'legacy': {
            'ENGINE': 'django.db.backends.mysql',
            'NAME': '#{DB_MARIADB_NAME}',
            'USER': '#{DB_MARIADB_USER}',
            'PASSWORD': '#{DB_MARIADB_PASSWORD}',
            'HOST': '#{MARIADB_IP}',
            'PORT': '#{MARIADB_PORT}',
        },
        'default': {
            'ENGINE': 'django.db.backends.postgresql',
            'NAME': '#{DB_POSTGRES_NAME}',
            'USER': '#{DB_POSTGRES_USER}',
            'PASSWORD': '#{DB_POSTGRES_PASSWORD}',
            'HOST': '#{POSTGRES_IP}',
            'PORT': '#{POSTGRES_PORT}',
        }
    }

  VM MANAGEMENT:
    Start all:    vagrant up
    Start one:    vagrant up mariadb|postgresql|adminer
    Stop all:     vagrant halt
    Stop one:     vagrant halt mariadb|postgresql|adminer
    SSH:          vagrant ssh mariadb|postgresql|adminer
    Destroy all:  vagrant destroy
    Status:       vagrant status

  VERIFICATION:
    ping #{MARIADB_IP}
    ping #{POSTGRES_IP}
    ping #{ADMINER_IP}
    mysql -h #{MARIADB_IP} -u root -p'#{DB_MARIADB_ROOT_PASSWORD}' -e "SELECT 1;"
    PGPASSWORD='#{POSTGRES_PASSWORD}' psql -h #{POSTGRES_IP} -U postgres -c "SELECT 1;"
    curl -I http://#{ADMINER_IP}

  LOGS:
    /vagrant/logs/

  TROUBLESHOOTING (Windows):
    If you get VERR_INTNET_FLT_IF_NOT_FOUND error:
    1. Win+R → ncpa.cpl → Disable/Enable VirtualBox Host-Only adapter
    2. See docs/TROUBLESHOOTING.md for more solutions

  SECURITY NOTE:
    - Each service runs on its own isolated VM
    - Accessible from host machine only (192.168.56.0/24)
    - NOT accessible from external networks
    - Default passwords are for DEVELOPMENT ONLY!

  ========================================================================
  MESSAGE

end