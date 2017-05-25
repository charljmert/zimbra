# README #

## Importing Outlook (.msg) files into Zimbra in bulk from disk

This repo contains scripts which help with importing email into zimbra
1. It details how to convert email from outlook (.msg) to rfc2822 (.eml)
2. It makes provision for importing emails for a given account in bulk, you only need to amend the bash snippet below to include the folders

### The following will import files from /home/user/emails/Inbox and /home/user/emails/Sent to user@email.co.za into the new /Archives folder
```bash
#
# Danie
#

# create Archives folder (doesn't handle nested directories)
echo createFolder /Archives | /opt/zimbra/bin/zmmailbox -z -m user@email.co.za

cd /home/user/emails/

# before
# /home/user/emails/Inbox/message1.msg

# convert to eml
for p in 'Inbox' 'Sent'; do find "$p" | /usr/local/bin/zimbra_convert_msg_to_eml.pl; done

# after (new .eml file for ever .msg file)
# /home/user/emails/Inbox/message1.msg
# /home/user/emails/Inbox/message1.msg.eml

# the following will now import all of the .eml files and create sub folders where needed.
# e.g. Archives/Inbox and Archives/Sent)
for p in 'Inbox' 'Sent'; do find "$p" -type f -iname "*.eml" | /usr/local/bin/zimbra_import.pl /Archives user@email.co.za | tee -a "$p".log; done

```

### TODO
- support nested folder creation
- create single command with args e.g.
```bash
./zimbra_import.pl /home/user/emails /Archives user@email.co.za
```