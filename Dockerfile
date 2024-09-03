# Utilisez une image de base Ubuntu minimaliste
FROM ubuntu

# Installer les outils nécessaires
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    unzip \
    zlib1g-dev \
    build-essential \
    libglfw3-dev \
    libfreetype6-dev \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libicu-dev \
    locales \
    && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

# Définir la locale par défaut
ENV LANG="en_US.UTF-8"

# Installer les dépendances système pour Android (ajustez selon votre distribution)
RUN apt-get update && apt-get install -y \
    libc6-dev \
    libncurses5-dev \
    libgtk-3-dev \
    libxxf86vm-dev \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    libfreetype6-dev \
    libasound2-dev \
    libxss-dev \
    libxkbcommon-x11-dev \
    && rm -rf /var/lib/apt/lists/*

# Créer un utilisateur non-root
RUN useradd -m -s /bin/bash flutteruser

# Télécharger et installer une version spécifique du Dart SDK en tant que root
RUN wget https://storage.googleapis.com/dart-archive/channels/stable/release/3.4.4/sdk/dartsdk-linux-x64-release.zip -O dartsdk.zip \
    && mkdir -p /usr/local/dart \
    && unzip dartsdk.zip -d /usr/local/dart \
    && rm dartsdk.zip

# Ajouter Dart au PATH
ENV PATH="$PATH:/usr/local/dart/dart-sdk/bin"

# Changer d'utilisateur
USER flutteruser

# Créer le répertoire de travail
WORKDIR /app

# Télécharger Flutter
RUN wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.10.5-stable.tar.xz -O flutter.tar.xz \
    && tar -xvf flutter.tar.xz

# Ajouter Flutter au PATH
ENV PATH="$PATH:/app/flutter/bin"

# Initialiser Flutter
RUN flutter config --enable-android
RUN flutter config --enable-ios
# Si vous avez besoin du support iOS

# Copier le code source dans le container
COPY . .

# Installer les dépendances Flutter
#RUN flutter pub get

# Commande pour exécuter les tests
#CMD [ "flutter", "test" ]
