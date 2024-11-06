FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive

# Install Apache and clean up apt cache
RUN apt-get update -y && apt-get install -y apache2 && apt-get clean

# Create the static web directory
RUN mkdir -p /var/www/html/staticweb

# Copy website files into the container
COPY . /var/www/html/staticweb/

# Configure Apache to serve your static website
RUN cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/staticweb.conf && \
    sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html/staticweb|' /etc/apache2/sites-available/staticweb.conf && \
    a2ensite staticweb.conf && \
    a2enmod rewrite

# Expose port 80 for the web server
EXPOSE 80

# Start Apache in the foreground (this is the main process in the container)
CMD ["apache2ctl", "-D", "FOREGROUND"]

