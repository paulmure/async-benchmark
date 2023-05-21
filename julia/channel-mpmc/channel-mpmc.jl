function test_mpmc(num_threads::Int)
    c::Channel{Int} = Channel{Int}(Inf)
    tasks::Vector{Task} = Vector{Task}()
    for _ = 1:num_threads
        push!(tasks,
            @task begin
                put!(c, 1)
                sleep(1)
                take!(c)
            end)
    end
    foreach(schedule, tasks)
    foreach(wait, tasks)
end

num_threads::Int = parse(Int, ARGS[1])
@time test_mpmc(num_threads)