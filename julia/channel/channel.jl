function test_mpsc(num_threads::Int)
    c = Channel(Inf)
    for _ = 1:num_threads
        schedule(@task begin
            sleep(1)
            put!(c, 1)
        end)
    end
    for _ = 1:num_threads
        take!(c)
    end
end

num_threads::Int = parse(Int, ARGS[1])
@time test_mpsc(num_threads)