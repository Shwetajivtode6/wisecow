# Use an official lightweight base image
FROM alpine:latest

# Install necessary packages
RUN apk add --no-cache bash curl

# Add the application source code
COPY . /app
WORKDIR /app

# Make the shell script executable
RUN chmod +x wisecow.sh

# Expose the port that the application will run on
EXPOSE 4499

# Run the application
CMD ["./wisecow.sh"]
