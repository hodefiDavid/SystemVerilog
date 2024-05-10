# python file to reverse a back slash to a forward slash
import os

# Get the current working directory
current_folder = os.getcwd()

# Replace the back slash with forward slash
current_folder = current_folder.replace('\\', '/')

print(current_folder)
