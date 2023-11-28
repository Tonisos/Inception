FROM debian:11

# Update package list and upgrade installed packages
RUN apt-get update && apt-get upgrade -y

# Install MariaDB server
RUN apt-get install mariadb-server -y 


# Copy the script into the container
COPY ./tools/launch-mariadb.sh .
# Make the script executable
RUN chmod +x launch-mariadb.sh

# Open port
EXPOSE		3306

# Run the script
ENTRYPOINT ["./launch-mariadb.sh"]
CMD		["mysqld", "--bind-address=0.0.0.0"]



