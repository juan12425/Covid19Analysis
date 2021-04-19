function countsnew(data)
    d = Dict{Int, Int}()
    for element in data
        if haskey(d, element)
            d[element]+=1
        else 
            d[element]=1
        end 
    end
    ks=collect(keys(d))
    vs=collect(values(d))
    p=sortperm(ks)
    
    return ks[p], vs[p]
    
            
end

vv = [1, 0, 1, 0, 1000, 1, 1, 1000]
countsnew(vv)

function probability_distribution(results)
    keys=results[1]
    values=results[2]
    valuessum=sum(values)
    valuesnew=results[2]./valuessum
    return keys, valuesnew
end

@enum InfectionStatus S I R

x=S

Int(x)

x=I

Int(I)

x=R

Int(x)

N=100

agents=[i=S for i in 1:N]

r=rand(1:100)

agents[r]=I


agents[r]

function step!(Vector_Agents, p_I)
    
    i=rand(1:length(Vector_Agents))
    a=Vector_Agents[i]
    
    if(a==I)
        
        i_2=i
        
        while (i_2 == i)
        i_2=rand(1:length(Vector_Agents))
        end
        
        r=rand()
        if ((r<p_I) && (Vector_Agents[i_2]==S))
            Vector_Agents[i_2]=I
        end
        
    end
        
            
end

function sweep!(Vector_Agents, p_I, N)
   

    for time in 1:N
       
        step!(Vector_Agents, p_I)
        
    end
        
end

function infection_simulation(N, p_I, T)
    
   agents=[i=S for i in 1:N]
   ri=rand(1:100) 
   agents[ri]=I
    
   Is=Int64[]
    
   for time in 1:T 
        
       sweep!(agents, p_I, N)
       push!(Is, count(agents.==I)) 
    
    end
    
    return Is
    
    
end

results=Array[]

for time in 1:50
   
    Is=infection_simulation(100, 0.02, 1000)
    push!(results, Is )
end

results

using Plots

s=plot();
xlabel!("sweep");
ylabel!("Number of Is");

for vector in results
    
 plot!(vector, alpha=0.5, leg=false)
    
end

s

using StatsBase

mt=mean(results)

plot!(mt, linewidth = 2, color="purple")

d=Array[]

c=1

for experiment in results
   
    exp=Float64[]
    for element in experiment
        mn=mt[c] 
        distance= (mn-element)^2
        push!(exp, distance)
        c+=1
    end
    
    push!(d, exp)
    c=1
        
end

d

σs=mean(d)

σ=σs.^(1/2)

plot(mt, linewidth = 2, yerr=σ, alpha=0.6, labels="Average Trajectory", markerstrokecolor="blue")
xlabel!("Sweep")
ylabel!("Infections")
title!("Error Bars")

mutable struct Agent
    status::InfectionStatus 
    num_infected::Int64
    Agent()=new(S, 0)
end

a=Agent()

a.status

a.num_infected

function step2!(Vector_Agents::Vector{Agent}, p_I)
    
    i=rand(1:length(Vector_Agents))
    a=Vector_Agents[i].status
    
    if(a==I)
        
        i_2=i
        
        while (i_2 == i)
        i_2=rand(1:length(Vector_Agents))
        end
        
        r=rand()
        if ((r<p_I) && (Vector_Agents[i_2].status==S))
            Vector_Agents[i_2].status=I
            Vector_Agents[i].num_infected+=1
        end
        
    end
        
            
end

function sweep2!(Vector_Agents::Vector{Agent}, p_I, N)
   

    for time in 1:N
       
        step2!(Vector_Agents, p_I)
        
    end
        
end

function num_infected_dist_simulation(N, p_I, T)
    
   agents=[Agent() for i in 1:N]
   ri=rand(1:N) 
   agents[ri].status=I
    
   n_iv=Int64[]
    
   for time in 1:T 
        
       sweep2!(agents, p_I, N)
    
    end
    
    for agent in agents
        
        
        n_i=agent.num_infected
        push!(n_iv, n_i)
        
    end
    
    counting=countsnew(n_iv)
    pd=probability_distribution(counting)
    
    return pd

end

pd= num_infected_dist_simulation(100, 0.02, 1000)


k=Array[]
v=Array[]

for N in 1:50
    pd=num_infected_dist_simulation(100, 0.02, 1000)
    push!(k, pd[1])
    push!(v, pd[2])
end



k

v

mxl=Int64[]
for vector in k
    
    for element in vector
        push!(mxl, element)
    end
    
end

maxlv=maximum(mxl)

newv=zeros(50, maxlv+1)

counter=1
counterf=1

for vector in k
    
    for element in vector
        
        
        newv[counter, element+1]=v[counter][counterf]
        
        counterf+=1   
    end
    
    counterf=1
    counter+=1
    
end
        

newv

mv=Float64[]

for counter in 1:maxlv+1
    
    m2=mean(newv[:, counter])
    push!(mv, m2)
    
end

mk=[n for n in 0:maxlv]

mv

scatter(mk, mv)

function step3!(Vector_Agents::Vector{Agent}, p_I, P_R)
    
    i=rand(1:length(Vector_Agents))
    a=Vector_Agents[i].status
    
    if(a==I)
        
        i_2=i
        
        while (i_2 == i)
        i_2=rand(1:length(Vector_Agents))
        end
        
        r=rand()
        if ((r<p_I) && (Vector_Agents[i_2].status==S))
            Vector_Agents[i_2].status=I
            Vector_Agents[i].num_infected+=1
        end
        
        
    end
    
    
    i2=rand(1:length(Vector_Agents))
    a2=Vector_Agents[i2].status
    r2=rand()
    
    if ((r2<P_R) && (a2==I) )
            
            Vector_Agents[i2].status=R
        
    end
end

function sweep3!(Vector_Agents::Vector{Agent}, p_I, P_R, N)
   

    for time in 1:N
       
        step3!(Vector_Agents, p_I, P_R)
        
    end
        
end

function simulation_with_recovery(N, p_I, P_R, T)
    
   agents=[Agent() for i in 1:N]
   ri=rand(1:N) 
   agents[ri].status=I
    
   n_iv=Int64[]
    
    
   Ss=Int64[]
   Is=Int64[]
   Rs=Int64[]
    
   for time in 1:T 
        
       sweep3!(agents, p_I, P_R, N)
        
       
        AS=0
        AI=0
        AR=0
        
       for agent in agents
            
            status=agent.status
            
            if status==S
                AS+=1
            end
            
            if status==I
                AI+=1
            end
            
            if status==R
                AR+=1
            end
       end
        
        push!(Ss, AS)
        push!(Is, AI)
        push!(Rs, AR)
    end
    
    
    
    for agent in agents
        
        
        n_i=agent.num_infected
        push!(n_iv, n_i)
        
    end
    
    counting=countsnew(n_iv)
    pd=probability_distribution(counting)
    
    return pd, Ss, Is, Rs

end

simwr=simulation_with_recovery(100, 0.1, 0.01, 1000)

p=plot()
plot!(simwr[2], label="Susceptible", color="blue")
plot!(simwr[3], label="Infected", color="purple")
plot!(simwr[4], label="Recovered", color="green")
title!("Epidemic Model")
ylabel!("Number")
xlabel!("Day/Sweep")

pd=simwr[1]

scatter(pd[1], pd[2], leg=false)
xlabel!("Number of Persons Infected by Person")

k=Array[]
v=Array[]

for N in 1:50
    pd=simulation_with_recovery(100, 0.1, 0.01, 1000)[1]
    push!(k, pd[1])
    push!(v, pd[2])
end


k

v

mxl=Int64[]
for vector in k
    
    for element in vector
        push!(mxl, element)
    end
    
end

maxlv=maximum(mxl)

newv=zeros(50, maxlv+1)

counter=1
counterf=1

for vector in k
    
    for element in vector
        
        
        newv[counter, element+1]=v[counter][counterf]
        
        counterf+=1   
    end
    
    counterf=1
    counter+=1
    
end

mv=Float64[]

for counter in 1:maxlv+1
    
    m2=mean(newv[:, counter])
    push!(mv, m2)
    
end

mk=[n for n in 0:maxlv]

scatter(mk, mv)
title!("Average Exponential Distribution of PIbP")
xlabel!("Persons infected by Person")

recovered=simwr[4]

counter=0
for number_r in recovered
    
    counter+=1
    
    if number_r == 100
        
        break
        
    end
    
end

R_d=counter

Infected=simwr[3]

firstday=Infected[1]

hday=Infected[100]

slope=(62-1)/(100-1)

mean_i=0
for i in 1:length(mk)
    
    mean_i+=(mk[i]*mv[i])
    
end

mean_i
