import requests

class StackExchangeAPI:
    def __init__(self, url):
        """
        Initializes the StackExchangeAPI class with a specified API URL.

        :param url: The URL of the Stack Exchange API endpoint to query.
        :type url: str
        """
        self.url = url

    def get_data(self):
        """
        Makes a GET request to the Stack Exchange API using the URL provided during class initialization
        and returns the JSON response.

        :rtype: dict or None
        :return: The JSON response from the API if the request is successful, None otherwise.
        """
        response = requests.get(self.url)
        if response.status_code == 200:
            return response.json()
        else:
            return None

    def process_data(self, data):
        """
        Processes the data obtained from the Stack Exchange API to extract specific information:
        the count of answered and unanswered questions, the question with the lowest views,
        the oldest and most recent question, and the question from the owner with the highest reputation.

        :param data: The JSON data obtained from the Stack Exchange API.
        :type data: dict

        :rtype: dict
        :return: A dictionary containing the processed information, including counts of answered and unanswered questions,
                 IDs of questions with the lowest views, oldest and most recent questions, and the owner ID with the highest reputation.
        """
        # Initialization of variables to store the required information
        answered_count = 0
        unanswered_count = 0
        lowest_views = float('inf')
        lowest_view_answer = None
        oldest_answer = {'creation_date': float('inf')}
        most_recent_answer = {'creation_date': 0}
        highest_reputation_owner = {'owner': {'reputation': 0}}

        for item in data['items']:
            if item['is_answered']:
                answered_count += 1
            else:
                unanswered_count += 1

            if item['view_count'] < lowest_views:
                lowest_views = item['view_count']
                lowest_view_answer = item

            if item['creation_date'] < oldest_answer['creation_date']:
                oldest_answer = item
            if item['creation_date'] > most_recent_answer['creation_date']:
                most_recent_answer = item

            if 'owner' in item and item['owner'].get('reputation', 0) > highest_reputation_owner['owner'].get('reputation', 0):
                highest_reputation_owner = item

        results = {
            'answered_count': answered_count,
            'unanswered_count': unanswered_count,
            'lowest_view_answer_id': lowest_view_answer['question_id'] if lowest_view_answer else None,
            'oldest_answer_id': oldest_answer['question_id'] if oldest_answer['creation_date'] != float('inf') else None,
            'most_recent_answer_id': most_recent_answer['question_id'] if most_recent_answer['creation_date'] != 0 else None,
            'highest_reputation_owner_id': highest_reputation_owner['owner']['user_id'] if highest_reputation_owner['owner'].get('reputation', 0) != 0 else None
        }

        return results

    def print_results(self, results):
        """
        Prints the results obtained from processing the Stack Exchange API data.

        :param results: The results obtained from the process_data method, containing counts of answered and unanswered questions,
                        IDs of questions with specific criteria, and the owner ID with the highest reputation.
        :type results: dict
        """
        for key, value in results.items():
            print(f"{key}: {value}")


if __name__ == "__main__":
    url = "https://api.stackexchange.com/2.2/search?order=desc&sort=activity&intitle=perl&site=stackoverflow"
    api = StackExchangeAPI(url)
    data = api.get_data()
    if data:
        results = api.process_data(data)
        api.print_results(results)
    else:
        print("Failed to get data from API.")


# Answer from console 

# answered_count: 25
# unanswered_count: 5
# lowest_view_answer_id: 78011968
# oldest_answer_id: 392643
# most_recent_answer_id: 78076016
# highest_reputation_owner_id: 2133