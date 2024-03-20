
 # Apache user data 
  user_data = base64encode(<<EOF
            #!/bin/bash
            sudo apt-get update -y
            sudo apt install -y apache2
            systemctl start apache2
            systemctl enable apache2
            EOF
  )
