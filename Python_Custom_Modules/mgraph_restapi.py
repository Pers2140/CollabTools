
import urllib.parse
import requests, json

class mgraph_rest_conn(object):
    
    def __init__(self,email,password,client_id,client_password,site_id):
        self.email = email
        self.password = password
        self.client_id = client_id
        self.client_password = client_password
        self.site_id = site_id

    def get_user_token(self):

        # address to request token from
        url = "https://login.microsoftonline.com/8c0ee380-52d5-49f7-a4a2-34cf2be7b0b9/oauth2/token"

        # Ask user information details to request token
        # ----------------------------------------------------------------
        # email = urllib.parse.quote(input("Please enter email: \n"))
        # password = urllib.parse.quote(input("please enter password: \n"))
        # client_id = input("Enter client ID \n")
        # client_secret = input("Enter client secret \n")
        # ----------------------------------------------------------------

        # payload=f'grant_type=password&client_id={client_id}&client_secret={client_secret}&resource=https%3A%2F%2Fgraph.microsoft.com&username={email}&password={password}'
        user_email = urllib.parse.quote(self.email)
        user_password = urllib.parse.quote(self.password)

        # request payload containing client id and client secret - currently hardcoded 
        payload=f'grant_type=password&client_id={self.client_id}&client_secret={self.client_password}&resource=https%3A%2F%2Fgraph.microsoft.com&username={user_email}&password={user_password}'

        headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'buid=0.ATYAgOMOjNVS90mkojTPK-ewudfqWYwD1ydKnlXJagBUyNI2AAA.AQABAAEAAAD--DLA3VO7QrddgJg7WevrwzXRBf53TBob6qbZZNibQYJLRn1fWp_-0da2yf5resER9eV_jHbKJ8tJEk3Ek9mUZ7PuHWsVpMI8_7nrAuW7t0jbDkCVnEjdIegdNGEz8yYgAA; esctx=PAQABAAEAAAD--DLA3VO7QrddgJg7WevrlM_1_7LDTR6-vcDgzsBD6W4z9tJrjKoj3BbDB966fRNXP9nxUB_WzohHE-X24Y6_KWnVugax_QGo03ZRfbwTYFMmhrljdUln2mpVLNMMVV6UO61tFTzmdVwHQ34SA-Vc--tAu_wMUIluOID0e4zMX_QOteTh2sAf0VS5U4GUwpsgAA; fpc=Al6oLhm8kABEh-fZyWWWvPOqTVxQAQAAAIYNd9sOAAAA; stsservicecookie=estsfd; x-ms-gateway-slice=estsfd'
        }

        # sends POST request
        response = requests.request("POST", url, headers=headers, data=payload)

        # Parses JSON response and store only access token parameter 
        user_access_token = json.loads(response.text)['access_token']

        return user_access_token

    def upload_user_file(self,drive_id,file_name,type):

        # URL to upload file
        url = f"https://graph.microsoft.com/v1.0/sites/{self.site_id}/drives/{drive_id}/root:/{file_name}:/content"

        # get Bearer token 
        user_token = self.get_user_token()
        # open file to be uploaded
        payload=open(file_name)
        # set headers and use Bearer token
        headers = {
        'Authorization': f'Bearer {user_token}',
        'Content-Type': type
        }

        # upload file
        response = requests.request("PUT", url, headers=headers, data=payload)

        # check if response was successful 
        if response.status_code:
            print(f'code {response.status_code} File was uploaded!')
        else:
            print ('Something went wrong ...')

        return json.loads(response)

def main():
    print ("You have imported the Microsoft Graph REST API module directly")

if __name__ == "__main__":
    main()



