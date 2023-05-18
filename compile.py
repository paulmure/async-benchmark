import os

os.chdir('./go')
os.system('go build')

os.chdir('../rust')
os.system('cargo build --release')