{ pkgs, ... }:

{
  users.users.ben = {
    isNormalUser = true;
    home = "/home/ben";
    shell = pkgs.zsh;
    hashedPassword = "$6$z1QURtjIw$.S1bY6JqYAUC4RVfHz3A1TZX1PU133NuqOcXzL3CwPgQeSSkv/QFxS9dmSJFHuQGTVixA4oZWfuakr9D6VJdl.";
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDO7DOBHKcJAgCpXWcwubLP4HkBFBnSvvGg/ND6R1D39qeSlC1sB2lM29jmEDlFsr5dlVlVmJnK8SQE/s9R1swwc3B/V/1pHvULDTvih/bLxUs5bBrmE4zcgqTBZxgDZ4s6Fu3JwXG3GGtTOE2sm9fqc/dKralSrnbYfTF3APCfRxjrXNN4PiU/i4CRfwa5oD0hFAfKeeYRBp1LbqSFbocYgwFu7XjiaE9VZAAtkAUSZLgJs9ExGX006zVv9rLPi8naaY5QMbva/n4Pk9Xo/Xl1aXnzb11za458t+W741GfFkPfTjRWZ1+IMiBRXH6tB+T7RQK637Hgq/W1/b6J0cwhAqPOeqQlg29GrHDl/ecSIYpedxG1ojzoJcx7xzlNB335v60lNylgB5nX6k6CmGJaiN7R3Z7lIiOiVaDYQiPveq4A+VROXwjGRRvyp3OkndTbSFSEeg+88B1AcESCxO1pxDOrQYJC1xlrgsEG1eCX3WOGs3XR/0E/4+aChSbBres= ben@Benjamins-MBP"
    ];
    extraGroups = [ "wheel" "docker" ];
  };
}
