> # Getting started

> To access Ninox, please visit https://ninox.dialogueone.com

## Installation

Ninox is a web-based application that runs on all browsers, so there is no need to install Ninox. However, we have discovered that using Firefox is best or even necessary for our needs when using Windows OS in order to be able to use the `mailto` links, which opens the Outlook application with prefilled information.

Therefore, if you are using Windows, please install the Firefox browser, Chrome should work on Mac OS.

### Microsoft 365.

If you are using your personal computer, you can install Office 365 to get access to Microsoft Outlook, Teams etc. This will ensure that you have the right tools to use with Ninox.

[See the installation instructions by following this link ](https://support.microsoft.com/en-us/office/download-and-install-or-reinstall-microsoft-365-or-office-2021-on-a-pc-or-mac-4414eaaf-0478-48be-9c42-23adc4716658)

### Where should I use Ninox?

Since we want to move away from the Remote Desktop environment, you should follow the next instructions on your computer rather than on the remote desktop.

## Setting up

There are a few settings that need to be updated in order to make the automations work as they should.

### Allowing – popups

Firefox by default blocks all pop-up windows, to fix this go to the `Settings->Search` and search for Pop-up click on the `exeptions…` button, once there, add `https://ninox.dialogueone.com` by copying the link and pasting it into `Address of web site` then click on the `Allow` button, afterwards save the changes.

### Setting default applications

Once you click on a button in Ninox (inside the browser) that initiates a transfer on application use i.e., Email, Phone (softphone or other); the browser's inbuilt functionality takes over and should open your preferred application.

By default, the browsers look at the operating systems defaults first, and offer you a choice of applications to use. We want to use Outlook and Softphone applications that have been set up for our needs.

### Default Firefox applications

To initiate this, select the `Pick an app` by double clicking on it, If the application doesn`t appear in the list you might need to search for them using the prompts given.

To manually select an application for this, go to the `Settings->Search` and type mailto, on the right side of the `Content Type` is `Action` clicking on the down arrow opens a selection of applications, select`Use Outlook`. It should also be possible to use the browser-based Outlook application (which is needed for some projects).

Similarly, when clicking on a phone number or a button that initiates a phone call, you must choose which application you want to use. As of writing, we use IP Visions Connect software, follow the same steps above to `Pick an app`.

### Default Windows applications

#### Windows 11

It might be necessary to change the defaults within the operating systems as well, to do this navigate to `Settings->Apps->Default apps` navigate to the bottom of the list and choose `Choose defaults by link type`, there, you can search for `mailto` and `tel`, choose Outlook for `mailto` and the desired phone software used for `tel` links.

#### Windows 10

On Windows 10 navigate to `Settings->Apps->Default apps`, scrolling down to the bottom of the list and selecting the `Choose default apps by protocol` will open the list of protocols, to find `mailto` or `tel` you will need to scroll down.
