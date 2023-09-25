"""Игра угадай число
Компьютер сам загадывает и сам угадывает число
"""

import numpy as np


def binary_search(number: int = 1) -> int:
    """Угадываем число от 1 до 100, используя алгоритм бинарного поиска

    Args:
        number (int, optional): Загаданное число. По умолчанию равно 1.

    Returns:
        int: Число попыток
    """
    # Нижняя граница
    low = 1

    # Верхняя граница
    high = 100

    # Середина будет рассчитана в цикле
    mid = 0

    # Счетчик попыток
    count = 0

    while low <= high:
        # Находим середину
        mid = (high + low) // 2

        # Запускаем счетчик
        count += 1

        # Если number больше, игнорируем половину чисел меньше
        if mid < number:
            low = mid + 1

        # Если number меньше, игнорируем половину чисел больше
        elif mid > number:
            high = mid - 1

        # Иначе number равен mid, поиск завершен, возвращаем count
        else:
            return count


def score_game(predict) -> int:
    """За какое количество попыток в среднем за 1000 подходов угадывает наш алгоритм

    Args:
        predict ([type]): функция угадывания

    Returns:
        int: среднее количество попыток
    """
    count_ls = []

    np.random.seed(1)  # фиксируем сид для воспроизводимости

    random_array = np.random.randint(1, 101, size=(1000))  # загадали список чисел

    for number in random_array:
        count_ls.append(predict(number))

    score = int(np.mean(count_ls))

    print(f"Ваш алгоритм угадывает число в среднем за: {score} попыток")
    return score


if __name__ == "__main__":
    # RUN
    score_game(binary_search)
