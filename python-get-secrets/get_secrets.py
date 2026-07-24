import boto3

from botocore.exceptions import ClientError


def get_password():

    secret_name = "maxwell-rds-dev-password-v1"

    region_name = "us-east-1"

    session = boto3.session.Session()

    client = session.client(
        service_name = 'secretsmanager',
        region_name = region_name
    )

    try:
        print(f"We are trying to get the Secret: {secret_name}...")

        response = client.get_secret_value(SecretId = secret_name)

    except ClientError as e:

        print(f"failed to get , Err: {e}")


    password = response['SecretString']
    print("Successfully get the password!")
    print(f"The password is: {password}")


if __name__ == "__main__":
    get_password()

