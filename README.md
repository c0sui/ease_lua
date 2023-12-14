# Ease
Библиотека для получения динамического значения на основе тайм-лайн вычислений (без привязки к FPS) с возможностью использования easing-функций. Доступно два варианта использования: вызов покадрово и с использованием callback-функции (едино-разовый вызов)

![demo_example](https://i.imgur.com/uxiRocj.gif)

```lua
--- @param from         number|float: начальное значение
--- @param dest         number|float: конечное значение
--- @param start_time   float: время начала анимации
--- @param easing       string: тип функции интерполяции (например, "linear", "easeInQuad" и т. д.)
--- @param callback     function: функция обратного вызова (не обязательный аргумент)
--- @return result      lua_thread/float: при callback использовании вернёт хэндлер потока, при обычном - значение
--- @return status      boolean: (только при обычном использовании) состояние выполнения функции

function ease(from, dest, start_time, easing, callback)
    return result, status
end
```

### Использование с постоянным вызовом:
```lua
local ease = require "ease"

function main()
    -- Начальное и конечное значение
    local A, B = 0, 100
    -- Время начала вычисления (через 5 секунд)
    local start_time = os.clock() + 5
    -- Длительность перехода от A к B (3 секунды)
    local duration = 3
    -- Функция сглаживания (в данном случае нет, то-есть линейная)
    local ease_method = "linear"
    
    while true do
        local value, status = ease(A, B, start_time, duration, ease_method)
        if status then
            print(value)
        end
        wait(0)
    end
end
```
> Через 5 секунд после запуска скрипта в консоль начнутся выводится числа от 0 до 100, status в нашем случае возвращает информацию о том, ведётся ли сейчас вычисление или нет (еще не началось/уже прошло)

### Использование с одиночным вызовом:
```lua
require "moonloader"
local ease = require "ease"

-- Всё тоже самое..
local A, B = 0, 100
local start_time = os.clock() + 5
local duration = 3
local ease_method = "linear"

-- ..но переменную для нашего изменяемого значения создаём заранее
local value = A

function main()
    if isKeyJustPressed(VK_SPACE) then
        -- Создаётся отдельный поток, в котором выполняется вычисление
        thread = ease(A, B, start_time, duration, ease_method, function(f)
            value = A
        end)
    end
    
    while true do
        -- Проверяем выполняется ли вычисление (если поток жив)
        if thread and not thread.dead then
            print(value)
        end
        wait(0)
    end
end
```
> Как видим, функция не вызывается постоянно в цикле, а всего лишь один раз, при нажатии на пробел, но тем не менее значение value будет изменятся в отдельном созданном библиотеке потоке

## Список easing-функций
- inSine, outSine, inOutSine
- inQuad, outQuad, inOutQuad
- inCubic, outCubic, inOutCubic
- inQuart, outQuart, inOutQuart
- inQuint, outQuint, inOutQuint
- inExpo, outExpo, inOutExpo
- inCirc, outCirc, inOutCirc
- inBack, outBack, inOutBack
- inElastic, outElastic, inOutElastic
- inBounce, outBounce, inOutBounce

## Итог
**Чем больше у вас кадров в секунду, тем больше раз изменится значение и тем меньше будет иметь расстояние до предыдущего, но так или иначе это займёт не более 3 секунд. Таким образом можно создавать анимации на основе этого значения, которые всегда будут выполнятся с одинаковой скоростью на любой частоте кадров. При желании можно указать сглаживание для анимации с использование easing-функций. Подробнее о них можно узнать и увидеть их визуальное представление можно на сайте: https://easings.net/, так же я создал небольшой демо-скрипт с примером использования этих функций.**