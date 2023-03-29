from office365.runtime.auth.user_credential import UserCredential
from office365.sharepoint.client_context import ClientContext


def get_sharepoint_context_using_user():

    # Get sharepoint credentials
    sharepoint_url = 'https://sriitdev2.sharepoint.com/sites/AD_profileinfo'

    # Initialize the client credentials
    user_credentials = UserCredential("useremail", "userpassword")

    # create client context object
    ctx = ClientContext(sharepoint_url).with_credentials(user_credentials)

    
    return ctx


def create_sharepoint_directory(dir_name: str):
    """
    Creates a folder in the sharepoint directory.
    """
    if dir_name:

        ctx = get_sharepoint_context_using_user()

        result = ctx.web.folders.add(f'Shared Documents/{dir_name}').execute_query()

        if result:
            # documents is titled as Shared Documents for relative URL in SP
            relative_url = f'Shared Documents/{dir_name}'
            return relative_url
        else:
            print ('something went wrong')

create_sharepoint_directory('test directory')

# get_sharepoint_context_using_user()

def upload_to_sharepoint(dir_name: str, file_name: str):

    sp_relative_url = create_sharepoint_directory(dir_name)
    ctx = get_sharepoint_context_using_user()

    target_folder = ctx.web.get_folder_by_server_relative_url(sp_relative_url)

    with open(file_name, 'rb') as content_file:
        file_content = content_file.read()
        target_folder.upload_file(file_name, file_content).execute_query()


upload_to_sharepoint("Shared Documents","test_text.txt")