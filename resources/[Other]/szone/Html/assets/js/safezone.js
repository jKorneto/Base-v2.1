class ZoneSafeHandler {
    constructor() {
        this.mainElement = $('.safezone-container');
        this.itemElement = $('.safezone-item');
        this.bodyElement = $('.safezone-body');
        this.descElement = $('#safezone-desc');

        this.isInSafezoneText = "Vous entrez en zone sécurisée";
        this.isNotInSafezoneText = "Vous sortez d'une zone sécurisée";
        this.defaultTime = 2500;
        this.isInSafezone = false;

        window.addEventListener('message', (event) => {
            const type = event.data.type;
            switch (type) {
                case 'safezone:set':
                    this.handleSafezone(event.data);
                    break;
                case 'safezone:setTimeMessage':
                    this.defaultTime = event.data.defaultTime;
                    break;
            }
        });
    }

    handleSafezone(data) {
        this.isInSafezone = data.isInSafezone;
    
        this.mainElement.removeClass('green red active');
        this.itemElement.removeClass('fade-in fade-out');
        this.bodyElement.removeClass('fade-out');
        this.mainElement.hide();
    
        setTimeout(() => {
            this.mainElement.show();
            this.itemElement.addClass('fade-in');
    
            if (this.isInSafezone) {
                this.mainElement.addClass("green");
                // this.descElement.text(this.isInSafezoneText);
    
                setTimeout(() => {
                    if (this.isInSafezone) {
                        this.itemElement.removeClass('fade-in');
                        this.itemElement.addClass('fade-out');
                    }
                }, this.defaultTime);
            } else {
                this.mainElement.addClass("red");
                // this.descElement.text(this.isNotInSafezoneText);
    
                setTimeout(() => {
                    if (!this.isInSafezone) {
                        this.itemElement.removeClass('fade-in');
                        this.itemElement.addClass('fade-out');
                    }
                }, this.defaultTime);
            }
        }, 100);
    }
    
}

new ZoneSafeHandler();