FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive


RUN apt-get update -y && apt-get install -y apache2 && apt-get clean

RUN mkdir -p /var/www/html/staticweb

COPY . /var/www/html/staticweb/

# Configure Apache to serve the static website
RUN cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/staticweb.conf && \
    sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html/staticweb|' /etc/apache2/sites-available/staticweb.conf && \
    a2ensite staticweb.conf && \
    systemctl reload apache2

# Expose port 80 to the outside world
EXPOSE 80

# Start Apache in the foreground when the container starts
CMD ["apache2ctl", "-D", "FOREGROUND"]
