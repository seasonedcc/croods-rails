---
id: requestResponseValidation
title: Request and Response validation
---

#### JSON schema

We use JSON schema to strong-type the API from a protocol point of view. Endpoints and their parameters are validated before even reaching the controller. This way, we don't need to write a lot of code to validate param types, presence, etc. Rails doesn't even see requests that are badly formatted.
