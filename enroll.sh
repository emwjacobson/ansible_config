#!/bin/bash -l

if [[ "$EUID" -ne 0 ]]; then
  echo "Script must be run as root!"
  exit 1
fi

get_distro() {
  if [ -f /etc/debian_version ]; then
    echo "debian"
  elif [ -f /etc/redhat-release ]; then
    echo "rhel"
  else
    echo "unknown"
  fi
}

distro=$(get_distro)

if [[ "${distro}" == "debian" ]]; then
  apt install -y curl wget sudo libuser
elif [[ "${distro}" == "rhel" ]]; then
  dnf install -y curl wget 
else
  echo "Unsupported distro"
  exit 1
fi

KEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC0pt323arG58oeGHqvGIeqyn7ksyml7+MVcKohCYtOBuqlsF3l2Vb9NbKYz91kKjdBHzfCFt3uabDewRRsCjdf/pjhIh0XL0LxTl4dwnZj7QHpyBDOY9qlmibkBjJOBaIijPD8QZL6IuxdNfCrVkOrjoDpMWM6DPXn75iXGV0P1GkJQ602joNjsKBjN2O2mYUHZLIQawHlPt6gnInvPPWIenO/ImPP8+n/m0URadGivOaJaTBTSZ8bB29CXdvSd72fP/6oJuAcKJVl2VL68kawBKekh9Rurg8hAopoVqCnW+pgJEsdcbMpU4K/hbUYebztoQ/dPhM8wlpqt6ES4weduCH5nBRu//xi/J4V1a/VykvCZyM6OexyHPeYWzOOkaeHq+AleMBe7ZL6TnAHe+dy1BAHqNjljgpzeUVqHP9Q3NL2Btj/GnGy/+fWjeAx8s1xyQWRPiej79WUAp8CwSEi2c0V0cTpHqio/V52z02Vzn+/cDsBghHRphTMzMEDpxs= ansible@docker"
KEY_FOLDER="/root/.ssh"
IP=$(hostname --all-ip-addresses | grep -Eio "10.20.*")

mkdir -p $KEY_FOLDER
echo $KEY >> $KEY_FOLDER/authorized_keys

echo "Do not forget to track this machine with Ansible!"
echo "Also enabling QEMU Guest Agent and CPU NUMA."
echo $IP

