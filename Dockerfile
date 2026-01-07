FROM python:3.12-slim-bookworm

# Install system dependencies
RUN apt-get update && apt-get install -y \
  gcc \
  g++ \
  make \
  git \
  libpq-dev \
  libldap2-dev \
  libsasl2-dev \
  libxml2-dev \
  libxslt1-dev \
  libjpeg-dev \
  libfreetype6-dev \
  liblcms2-dev \
  libwebp-dev \
  libtiff5-dev \
  libopenjp2-7-dev \
  fonts-liberation \
  postgresql-client \
  python3-dev \
  && rm -rf /var/lib/apt/lists/*

# Create odoo user
RUN useradd -ms /bin/bash odoo

# Create data directory with proper permissions
RUN mkdir -p /var/lib/odoo && chown -R odoo:odoo /var/lib/odoo

WORKDIR /opt/odoo

# Copy requirements and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy Odoo source
COPY --chown=odoo:odoo . .

USER odoo

EXPOSE 8069

CMD ["python3", "odoo-bin", "--dev=all"]