import subprocess
import os

def _lsb_release_info():
    """
    Get the information items from the lsb_release command output.
    Returns:
        A dictionary containing all information items.
    """
    with open(os.devnull, 'w') as devnull:
        try:
            cmd = ('lsb_release', '-a')
            stdout = subprocess.check_output(cmd, stderr=devnull)
        except OSError:  # Command not found
            return {}
    return stdout


print(subprocess.check_output(["ls", "-l", "/dev/null"], stderr=subprocess.STDOUT))
try:
    print(subprocess.check_output(["lsb_release2"], stderr=subprocess.STDOUT))
except OSError:
    pass
print(_lsb_release_info())