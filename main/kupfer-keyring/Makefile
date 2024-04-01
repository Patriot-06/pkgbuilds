SHELL := bash

BUILD_DIR = .

PREFIX = /usr/local

KEYRING_NAME = kupfer
KEYRING_MASTER_FILES = $(KEYRING_NAME).master.pgp
#KEYRING_REVOKED_FILES = $(shell if [[ -d revoked/ ]] ; then echo revoked/*.pgp ; fi)
KEYRING_REVOKED_FILES = $(wildcard *.pgp.revoked)
KEYRING_FILES = $(KEYRING_MASTER_FILES) $(KEYRING_NAME).build.pgp $(KEYRING_REVOKED_FILES)


KEYSERVER = 'hkp://pgp.mit.edu'
GPG = "gpg --quiet --batch --no-tty --no-permission-warning --keyserver "${KEYSERVER}" --homedir ${TMPDIR}"



$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/$(KEYRING_NAME).gpg: $(BUILD_DIR) $(KEYRING_FILES) $(BUILD_DIR)/$(KEYRING_NAME)-trusted $(BUILD_DIR)/$(KEYRING_NAME)-revoked
	cat $(KEYRING_FILES) > "$@"

$(BUILD_DIR)/$(KEYRING_NAME)-trusted: $(BUILD_DIR) $(KEYRING_FILES)
	(for f in $(KEYRING_MASTER_FILES) ; do gpg --with-fingerprint --verbose "$$f" 2>&1 | awk '/^sig/{ print $$2 }' ; done)  | sort -u | xargs -i echo "{}:4:" > "$@"

$(BUILD_DIR)/$(KEYRING_NAME)-revoked: $(BUILD_DIR) $(KEYRING_REVOKED_FILES)
	revoked=($(KEYRING_REVOKED_FILES)) && \
	(for f in "$${revoked[@]}" ; do gpg --with-fingerprint --verbose  2>&1 | awk '/^sig/{ print $2 }' ; done) | sort -u > "$@"

install: $(BUILD_DIR)/$(KEYRING_NAME).gpg $(BUILD_DIR)/$(KEYRING_NAME)-trusted $(BUILD_DIR)/$(KEYRING_NAME)-revoked
	install -dm755 $(DESTDIR)$(PREFIX)/share/pacman/keyrings/
	install -m0644 $(BUILD_DIR)/$(KEYRING_NAME){.gpg,-trusted,-revoked} $(DESTDIR)$(PREFIX)/share/pacman/keyrings/

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/share/pacman/keyrings/$(KEYRING_NAME){.gpg,-trusted,-revoked}
	rmdir -p --ignore-fail-on-non-empty $(DESTDIR)$(PREFIX)/share/pacman/keyrings/

clean:
	rm -fv $(BUILD_DIR)/$(KEYRING_NAME){.gpg,-trusted,-revoked}

cleanbuild:
	$(MAKE) clean
	$(MAKE)

.PHONY: install uninstall clean
