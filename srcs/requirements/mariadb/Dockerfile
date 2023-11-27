FROM debian:11

# Update package list and upgrade installed packages
RUN apt-get update && apt-get upgrade -y

# Install MariaDB server and Vim
RUN apt-get install -y mariadb-server 

# Copy MariaDB configuration
COPY /conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf


# Copy the script into the container
COPY ./tools/launch-mariadb.sh .
# Make the script executable
RUN chmod +x launch-mariadb.sh

# Open port
EXPOSE		3306

# Run the script
ENTRYPOINT ["./launch-mariadb.sh"]boss

