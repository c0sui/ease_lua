# Ease
Библиотека для получения динамического значения на основе тайм-лайн вычислений (без привязки к FPS) с возможностью использования easing-функций. Использование доступно в двух вариантах: постоянный вызов в цикле, либо и с использованием callback-функции (единоразовый вызов)

![demo_example](https://i.imgur.com/uxiRocj.gif)
*Демонстрация работы библиотеки*

```lua
-- * - обязательные аргументы
--- @param from*        float: начальное значение
--- @param dest*        float: конечное значение
--- @param start_time   float: время начала анимации
--- @param duration*    float: время выполнения анимации
--- @param easing       string: тип функции интерполяции (например, "linear", "easeInQuad" и т. д.)
--- @param callback     function: функция обратного вызова (не обязательный аргумент)
--- @return result      lua_thread/float: при callback использовании вернёт хэндлер потока, при обычном - значение
--- @return status      int: (только при обычном использовании) состояние выполнения функции (0-2)

function ease(from, dest, start_time, duration, easing, callback)
    return result, status
end
```

### Использование с постоянным вызовом:
```lua
local ease = require "ease"

function main()
    -- Начальное и конечное значение
    local A, B = 0, 1
    -- Время начала вычисления (через 5 секунд)
    local start_time = os.clock() + 5
    -- Длительность перехода от A к B (3 секунды)
    local duration = 3.0
    -- Функция сглаживания (в данном случае нет, то-есть линейная)
    local ease_method = "linear"
    
    while true do
        local value, status = ease(A, B, start_time, duration, ease_method)
        if status == 1 then
            print(value)
        end
        wait(0)
    end
end
```
> Через 5 секунд после запуска скрипта в консоль начнутся выводится числа от 0 до 1, status в нашем случае возвращает информацию о том, на каком сейчас этапе выполнение
Статусы:
`0` - выполнение не началось
`1` - идёт выполнение
`2` - выполнено

### Использование с одиночным вызовом:
```lua
require "moonloader"
local ease = require "ease"

local A, B = 0, 1
local duration = 3.0
local ease_method = "linear"

-- Создаём заранее переменные для значения, статуса и тела потока
local value = A
local status = 0
local thread = nil

function main()
    if isKeyJustPressed(VK_SPACE) then
        -- Завершаем предыдущее выполнение, если оно ещё не закончилось
        if thread ~= nil and not thread.dead then
            thread:terminate()
        end
        -- Время начала можно не указывать, укажется автоматически текущее
        -- Создаётся отдельный поток, в котором выполняется вычисление
        thread = ease(A, B, nil, duration, ease_method, function(v, st)
            value = A
            status = st
        end)
    end
    
    while true do
        if status == 1 then
            print(value)
        end
        wait(0)
    end
end
```
> Как видим, функция не вызывается постоянно в цикле, а всего лишь один раз, при нажатии на пробел, но тем не менее значение value будет изменятся в отдельном созданном библиотеке потоке

## Список easing-функций
- inSine,       outSine,        inOutSine
- inQuad,       outQuad,        inOutQuad
- inCubic,      outCubic,       inOutCubic
- inQuart,      outQuart,       inOutQuart
- inQuint,      outQuint,       inOutQuint
- inExpo,       outExpo,        inOutExpo
- inCirc,       outCirc,        inOutCirc
- inBack,       outBack,        inOutBack
- inElastic,    outElastic,     inOutElastic
- inBounce,     outBounce,      inOutBounce

## Итог
**Чем больше у вас кадров в секунду, тем больше раз изменится значение и тем меньше будет иметь расстояние до предыдущего, но так или иначе это займёт ровно N секунд. Таким образом можно создавать анимации на основе этого значения, которые всегда будут выполнятся с одинаковой скоростью на любой частоте кадров. При желании можно указать сглаживание для анимации с использование easing-функций. Подробнее о них можно узнать и увидеть их визуальное представление можно на сайте: https://easings.net/, так же я создал небольшой демо-скрипт с примером использования этих функций**