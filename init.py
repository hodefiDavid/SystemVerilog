#initilize environment for verification

import os
import sys

def init(folder_name):
    # create a directory for the verification environment
    if not os.path.exists(folder_name):
        os.makedirs(folder_name)

def create_driver(folder_name):
    # create a sv file for the driver inside the verification environment
    driver_file = open(folder_name + "/driver.sv", "w")
    # write the driver code
    
    driver_file.close()

def create_monitor(folder_name):
    # create a sv file for the monitor inside the verification environment
    monitor_file = open(folder_name + "/monitor.sv", "w")
    monitor_file.close()

def create_top(folder_name):
    # create a sv file for the top inside the verification environment
    top_file = open(folder_name + "/top.sv", "w")
    top_file.close()

def create_interface(folder_name):
    # create a sv file for the interface inside the verification environment
    interface_file = open(folder_name + "/interface.sv", "w")
    interface_file.close()

def create_enviroment(folder_name):
    # create a sv file for the enviroment inside the verification environment
    env_file = open(folder_name + "/enviroment.sv", "w")
    env_file.close()

def create_transaction(folder_name):
    # create a sv file for the transaction inside the verification environment
    transaction_file = open(folder_name + "/transaction.sv", "w")
    transaction_file.close()

def create_scordboard(folder_name):
    # create a sv file for the scordboard inside the verification environment
    scordboard_file = open(folder_name + "/scordboard.sv", "w")
    scordboard_file.close()

def create_random_test(folder_name):
    # create a sv file for the random_test inside the verification environment
    random_test_file = open(folder_name + "/random_test.sv", "w")
    random_test_file.close()

def create_generator(folder_name):
    # create a sv file for the generator inside the verification environment
    generator_file = open(folder_name + "/generator.sv", "w")
    generator_file.close()

def create_reference(folder_name):
    # create a sv file for the reference inside the verification environment
    reference_file = open(folder_name + "/reference.sv", "w")
    reference_file.close()


def create_run_file(folder_name):
    # create a do file for runinig the verification environment
    do_file = open(folder_name + "/run.do", "w")
    do_file.close()
