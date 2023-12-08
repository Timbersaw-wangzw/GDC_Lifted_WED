classdef robFnc<handle
    properties   %属性
        method
        e2
        tau2
        omega
        omega2
        kappa
        dkappa
        loss
    end
    methods   %方法
        function obj=robFnc(e2,tau2,m)
            obj.e2=e2;
            obj.tau2=tau2;
            obj.method=m;
            switch m
                case 'TUKEY'
                    tukey(obj)
                case 'Geman_McClure'
                    Geman_McClure(obj);
                case 'WELSCH'
            end
        end
        Geman_McClure(obj);
        tukey(obj);
    end
end
function Geman_McClure(obj)
    m_d_tau2=obj.tau2;
    m_d_e2=obj.e2;
    m_d_tau=sqrt(m_d_tau2);
    w=sqrt(2*m_d_tau2/(m_d_e2+m_d_tau)^2);
    obj.loss=m_d_tau*m_d_e2/(m_d_tau+m_d_e2);
    obj.omega=w;
    obj.omega2=w*2;
    obj.kappa=sqrt(m_d_tau)*(w - sqrt(2));
    obj.dkappa=sqrt(m_d_tau);
end
function tukey(obj)
    m_d_tau2=obj.tau2;
    m_d_e2=obj.e2;
    m_d_tau=sqrt(m_d_tau2);
   
    w = max(0.0, 1.0 - m_d_e2 / m_d_tau2);
    obj.omega=w;
    obj.omega2=w^2;
    f=sqrt(1/3);
    obj.kappa=f * m_d_tau * (w - 1)*sqrt(2*w+1);
    obj.dkappa=f * m_d_tau / sqrt(2*w+1);
    r4 = m_d_e2*m_d_e2;
    tau4 = m_d_tau2*m_d_tau2;
    if m_d_e2<m_d_tau2
        obj.loss=m_d_e2*(3.0 - 3*m_d_e2/m_d_tau2 + r4/tau4)/6.0;
    else
        obj.loss= m_d_tau2/6.0;
    end
end