FROM debian:buster

# Copy launch script
COPY ./tools/launch_mdb.sh .

# Install dependencies
RUN apt-get update \
    && apt-get install -y mariadb-server \
    && chmod +x launch_mdb.sh

# Expose port
EXPOSE 3306

# Set entrypoint
ENTRYPOINT ["./launch_mdb.sh"]

# Default command
CMD ["mysqld", "--bind-address=0.0.0.0"]
