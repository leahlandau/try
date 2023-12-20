import os
import sys

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))
import config.config_variables


def build_email_body( sub_name, sub_id, sub_activity, cost):
    body = ''
    if not sub_activity or cost:
        body += f"\n subscription {sub_name} :{sub_id}"
    if not sub_activity:
        body += f"\n  לא היה בשימוש במשך השבועיים האחרונים במידה ולא תתבצע כניסה ל subscription בשבוע הקרוב, ה subscription ימחק."
    if cost:
        cost_set = config.config_variables.cost
        body += f"\n העלות של ה subscription נמוכה מ{cost_set}"
    return body

def build_email_body_to_excel( sub_activity, cost):
    body = ''
    if not sub_activity:
        body += f"ה-subscription לא היה בשימוש בזמן האחרון."
    if cost:
        cost_set = config.config_variables.cost
        body += f"\n העלות של ה subscription נמוכה מ{cost_set}"
    return body
