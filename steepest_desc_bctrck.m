function [xk,fk,gradf_norm, k, xseq,btseq]=steepest_desc_bctrck...
    (x0,f,gradf,alpha0,kmax,tolgrad,c1,rho,btmax,findiff_enable)

    xk=x0;
    k=0;
    xseq=zeros(size(x0));
    xseq(:,1)=x0;
    reached=0;
    btseq=zeros(kmax);
    for k=1:kmax
        alphak=alpha0;
        count=0;
        p=-gradf(xk);
        while count<=btmax && f(xk+alphak*(p))>armijo(xk,c1,alphak,f,gradf)
            alphak=alphak*rho;
            count=count+1;
        end
        btseq(k)=count;
        p=-gradf(xk);
        xk=xk+alphak*(p);
        xseq=[xseq xk];
        gradf_norm=norm(p);
        if norm(p)< tolgrad
           reached=1;
           fprintf('reached the tollerance %f\n',tolgrad)
           break
        end
    end
    fk=f(xk);
    x_seq=xseq(:,k);
    if reached==0 
        fprintf('couldnt reach the tollerance %d at step %d\n',tolgrad,kmax)
    end
end

function value=armijo(xk,c1,ak,f,gradf)
    value=f(xk)+c1*ak*norm(gradf(xk));
end