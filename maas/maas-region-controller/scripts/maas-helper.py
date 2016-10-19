#!/usr/bin/env python3

# TODO(alanmeadows) this script does nothing yet but
# eventually it will manage our maas networks using
# the api

import oauth.oauth as oauth
import httplib2
import uuid

def perform_API_request(site, uri, method, key, secret, consumer_key):
    resource_tok_string = "oauth_token_secret=%s&oauth_token=%s" % (
        secret, key)
    resource_token = oauth.OAuthToken.from_string(resource_tok_string)
    consumer_token = oauth.OAuthConsumer(consumer_key, "")

    oauth_request = oauth.OAuthRequest.from_consumer_and_token(
        consumer_token, token=resource_token, http_url=site,
        parameters={'oauth_nonce': uuid.uuid4().hex})
    oauth_request.sign_request(
        oauth.OAuthSignatureMethod_PLAINTEXT(), consumer_token,
        resource_token)
    headers = oauth_request.to_header()
    url = "%s%s" % (site, uri)
    http = httplib2.Http()
    return http.request(url, method, body=None, headers=headers)

# API key = '<consumer_key>:<key>:<secret>'
# response = perform_API_request(
#    'http://192.168.3.51/MAAS/api/2.0', '/nodes/?op=list', 'GET', 'FmLaaNZjXQUf76qC5E', '4bbAQaP9aqhSK7JrrdKLKF5qpLynPHSc',
#    'Rm9L8J3cwfmt5WZe9V')
#
# print(response)