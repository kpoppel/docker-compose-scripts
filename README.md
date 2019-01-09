# docker-compose-scripts
My docker compose scripts for my Raspberry PI 3 B+

# SSH setup:
```bash
   ssh-keygen -t rsa -b 4096 -C "4174578+kpoppel@users.noreply.github.com"
   ssh-add ~/.ssh/id_rsa
   cat ~/.ssh/id_rsa.pub
   ssh -T git@github.com
```

# SSH Agent:
```bash
   eval $(ssh-agent -s)
   ssh-add ~/.ssh/id_rsa
```
# Cloning the repository:
```bash
   git clone git@github.com:/kpoppel/docker-compose-scripts
```

# The docker-compose scripts:

