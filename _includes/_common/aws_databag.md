### AWS Credentials

Lots of cookbooks rely on chef "knowing" your AWS access keys.

Right now, this is handled by an encrypted data bag. There are far better ways
to handle secrets with chef but for simplicity an easier adoption an encrypted
data bag is chosen here.

First, lets create our secret key (Make sure you **do not** check this file in
to source control).

```
$ openssl rand -base64 512 | tr -d '\r\n' > .chef/encryption_key
```

Now, using this key, we will create en encrypted data bag

```
$ bin/knife data bag create aws main --secret-file .chef/encryption_key
```

This will open your default editor with a JSON that looks like this

```javascript
{
  "id": "main"
}
```

You need to add your AWS keys this way:

```javascript
{
  "id": "main"
  "aws_access_key_id": "YOUR_ACCESS_KEY",
  "aws_secret_access_key": "YOUR_SECRET_KEY"
}
```

Verify that the data bag is encrypted

```
$ bin/knife data bag show aws main
```

This should output something similar to this

```
WARNING: Encrypted data bag detected, but no secret provided for decoding.  Displaying encrypted data.
aws_access_key_id:
  cipher:         aes-256-cbc
  encrypted_data: STYb5AdscZfyRidV/BVNjCkfeWNeECG+ZHFdemDbAg/aAuTHck+PgUSycWdw
  A7Iz

  iv:             epQltD8GbLbnB9VmUvYMLw==

  version:        1
aws_secret_access_key:
  cipher:         aes-256-cbc
  encrypted_data: u1V/APx3lhjNWlU2/VjrF3OfL4Q4sfU3XKHRBuoIC8P7Y6utTD0y7qDu7GjI
  SVM3Bm/t+3kijGTmENhZ0SWFVw==

  iv:             DFqi5fSOEoB7gik90WcuUg==

  version:        1
id:                    main
```
