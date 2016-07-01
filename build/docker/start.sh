#!/bin/bash
####################################################
#################### SUPERVISOR ####################
####################################################
__run_supervisor() {
    echo "Running the run_supervisor function."
    supervisord -n
}

####################################################
####################### PHP ########################
####################################################
__run_php() {
    echo "Running the php info function."
    php -i
}


# Call all functions
__run_supervisor
__run_php