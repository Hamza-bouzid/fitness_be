import logging
import os
import traceback
from time import tzset

os.environ["TZ"] = "Europe/Rome"
tzset()

logger = logging.getLogger()
logger.setLevel(logging.INFO)
if os.getenv("DEBUG", None) == "1":
    logger.setLevel(logging.DEBUG)


def lambda_handler(event: dict, context):
    try:
        if event.get("resource"):
            return {
                "statusCode": 200,
                "body": "Api Gateway"
            }
        return {
            "statusCode": 200,
            "body": "AWS Events"
        }

    except Exception:
        logger.error(traceback.format_exc())
        return {"statusCode": 500, "body": "Internal Server Error"}
