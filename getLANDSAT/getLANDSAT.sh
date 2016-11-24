#===============================================================================
# DOCUMENTATION:
#===============================================================================
#***landsat-util development seed***********

#$: sudo apt-get update
#$: sudo apt-get install python-pip python-numpy python-scipy libgdal-dev libatlas-base-dev gfortran libfreetype6-dev
#$: pip install landsat-util

#i had to upgrade setuptools:
#sudo pip install --upgrade setuptools

#and do this from githunb issues page:
#https://github.com/developmentseed/landsat-util/issues/138

#Try to follow these steps: It works for me and I use Mac OSX El Capitan.

#- Install virtualenv
#pip install virtualenv virtualenvwrapper

#- Setup virtualenvwrapper in ~/.bash_profile. Add these lines (nano editor )to your ~/.bash_profile:

#export LC_ALL=en_US.UTF-8
#export LANG=en_US.UTF-8
#cp ~/.bash_profile ~/.bash_profile-org
#printf '\n%s\n%s\n%s' '# virtualenv' 'export WORKON_HOME=~/virtualenvs' \
#'source /usr/local/bin/virtualenvwrapper.sh' >> ~/.bash_profile

#- Enable the environment.From terminal enter:

#source ~/.bash_profile
#mkdir -p $WORKON_HOME
#mkvirtualenv landsat8

#- Install landsat-util. First upgrade pip.
#pip install --upgrade pip
#pip install --upgrade landsat-util

#- Thats all. From terminal enter 'landsat -h'.

#docs:

#https://pythonhosted.org/landsat-util/overview.html#download


#===============================================================================
# CODE
#===============================================================================
 landsat download LC80090452014008LGN00


