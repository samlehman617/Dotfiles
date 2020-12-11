# dotfiles
Setup via ansible 🤖 Requires `2.5.0+`

![zsh][zsh.png]

## Installation
1. Clone this repo and run `make all` from inside the `dotfiles` directory
	```
    git clone https://github.com/samlehman617/dotfiles.git
    make -C dotfiles all
	```
 
    > The Makefile instructs you on what it requires e.g. `NAME`, `EMAIL`, `Password` (refers to your SUDO password)


### Step-by-step 	
1. Edit the `templates/.gitconfig` file with your own `user.name` and `user.email`, and move it to `home/.gitconfig`

    ```
    [user]
    	name = samlehman617 
    	email = samlehman617@gmail.com
    ```

1. [OPTIONAL] Install `pip`, if not yet installed on the machine
	```
    sudo easy_install pip
	```

1. [OPTIONAL] Install `ansible`, if not yet installed on the machine
	```
    sudo pip install ansible
    
    # [Ubuntu]
    sudo pip install --prefix /usr/local ansible
	```

1. Run the playbook to setup dotfiles, provide `become` i.e. SUDO password
	```
    cd ansible/
    ansible-playbook setup-dotfiles.yml --ask-become-pass
    
    # ... OR when ansible/hosts is not yet symlinked into place
    ansible-playbook -i hosts setup-dotfiles.yml --ask-become-pass 
	```
    > Note: `become` i.e. SUDO password is required to ensure `docker-py` is installed

## References
1. [Ansible | installation]
1. [Ansible | tips n tricks]
1. [Homebrew]
1. [`ansible/ansible#51513`](https://github.com/ansible/ansible/issues/51513#issuecomment-459150769)
1. [`ansible/ansible#54347`](https://github.com/ansible/ansible/pull/54347)

[Ansible | installation]: http://docs.ansible.com/ansible/latest/intro_installation.html#latest-releases-via-pip
[Ansible | tips n tricks]: https://ansible-tips-and-tricks.readthedocs.io/en/latest/os-dependent-tasks/variables/
[Homebrew]: https://brew.sh/
[setup playbook]: ./ansible/setup-dotfiles.yml
[filetree]: https://docs.ansible.com/ansible/devel/plugins/lookup/filetree.html
[zsh.png]: docs/zsh.png

## To-Do
- [] Fix asdf
- [] Auto-install fonts & generate NERDFonts
- [] Switch to ansible's default method of installing packages
- [] Restructure directories to have task & vars for each major component
- [] Install all my other software
- [] Separate repos into dotfiles, ansible dotfile manager, scripts, secrets, etc.
- [] Create roles for basic PC, development, media editing, and server hosts
- [] Support flatpaks
- [] Create GitHub action to test whether playbook completes successfully
- [] Interactive configuration?
- [] WSL support
- [] Update README with customization instructions
- [] Implement desktop environment configuration
- [] Add hosts for all my PCs + cloud infra
