--********************************************************************************************
--* VHDL-SIKE: a speed optimized hardware implementation of the 
--*            Supersingular Isogeny Key Encapsulation scheme
--*
--*    Copyright (c) Brian Koziel, Reza Azarderakhsh, and Rami El Khatib
--*
--********************************************************************************************* 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use IEEE.MATH_REAL.ALL;

--ADD SUB GENERIC
entity add_sub_gen is
    generic(
        N : integer := 220;
        L : integer := 20;
        H : integer := 3);
    port (
        a_i           : in std_logic_vector(N-1 downto 0);
        b_i           : in std_logic_vector(N-1 downto 0);
        sub_i         : in std_logic; -- 0 = add, 1 = sub
        c_i           : in std_logic;
        res_o         : out std_logic_vector(N-1 downto 0);
        c_o           : out std_logic);
end add_sub_gen;

architecture structural of add_sub_gen is

    component compact is
        port (
            a1      : in std_logic;
            b1      : in std_logic;
            a2      : in std_logic;
            b2      : in std_logic;
            A_out   : out std_logic;
            B_out   : out std_logic);
    end component;
    
    component adder is
        generic (N : integer := 8);
        port (
            a       : in std_logic_vector(N-1 downto 0);
            b       : in std_logic_vector(N-1 downto 0);
            cin     : in std_logic;
            s       : out std_logic_vector(N-1 downto 0);
            cout    : out std_logic);
    end component;
    
    component expand is
        port (
            a1      : in std_logic;
            b1      : in std_logic;
            a2      : in std_logic;
            b2      : in std_logic;
            S_in    : in std_logic;
            s1      : out std_logic;
            s2      : out std_logic);
    end component;

--    function get_max_H (N: integer; H: integer) return integer is
--        constant log2_N : integer := integer(log2(real(N)));
--        variable res : integer;
--    begin
--        if H < log2_N then
--            return H;
--        else
--            return log2_N;
--        end if;
--    end get_max_H;                  -- get_max_H = H = 2
    
    constant max_H : integer := 3;
    type h_int_arr is array(0 to max_H) of integer;
    type h_arr is array (0 to max_H) of std_logic_vector(N-1 downto 0);

    function get_H_total (L:integer; N:integer; H:integer) return h_int_arr is
        variable t : integer;
        variable res: h_int_arr;
    begin
        res(0) := N;
        
        for i in 0 to H-1 loop
            t := res(i) - (res(i) - (2*i+1)*L)/2;
            if t < res(i) then
                res(i+1) := t;
            else
                res(i+1) := res(i);
            end if;
        end loop;
        
        return res;

    end get_H_total;
    
    function get_H_start (L:integer; H:integer; ht: h_int_arr) return h_int_arr is
        variable s : integer;
        variable res: h_int_arr;
    begin
        res(0) := 0;
        
        for i in 0 to H-1 loop
            s := i * L;
            if ht(i+1) < ht(i) then
                res(i+1) := s;
            else
                res(i+1) := ht(i+1);
            end if;
        end loop;
        
        return res;

    end get_H_start;
    
    function get_H_finish (L:integer; H:integer; ht: h_int_arr; hs: h_int_arr) return h_int_arr is
        variable f : integer;
        variable res: h_int_arr;
    begin
        res(0) := 0;
        
        for i in 0 to H-1 loop
            f := ht(i+1) - (ht(i) - ht(i+1)) - hs(i+1);
            if ht(i+1) < ht(i) then
                res(i+1) := f;
            else
                res(i+1) := 0;
            end if;
        end loop;
        
        return res;
        
    end get_H_finish;
    
    constant ht : h_int_arr := get_H_total(L,N,max_H);
    constant hs : h_int_arr := get_H_start(L,max_H,ht);
    constant hf : h_int_arr := get_H_finish(L,max_H,ht,hs);
    
    signal a_compact : h_arr;
    signal b_compact : h_arr;
    signal s_expand  : h_arr;

begin
    a_compact(0) <= a_i;
    b_compact(0) <= b_i when sub_i = '0' else not b_i;
    
    compacts: for i in 0 to max_H-1 generate
        constant pt : integer := ht(i);
        constant nt : integer := ht(i+1);
        constant s : integer := hs(i+1);
        constant f : integer := hf(i+1);

    begin
        a_compact(i+1)(s-1 downto 0) <= a_compact(i)(s-1 downto 0);
        b_compact(i+1)(s-1 downto 0) <= b_compact(i)(s-1 downto 0);
        compact_gen: for j in 0 to nt-f-s-1 generate
            compact_inst: compact
            port map(
                a1      => a_compact(i)(s+2*j),
                b1      => b_compact(i)(s+2*j),
                a2      => a_compact(i)(s+2*j+1),
                b2      => b_compact(i)(s+2*j+1),
                A_out   => a_compact(i+1)(s+j),
                B_out   => b_compact(i+1)(s+j));
        end generate;
        
        a_compact(i+1)(nt-1 downto nt-f) <= a_compact(i)(pt-1 downto pt-f);
        b_compact(i+1)(nt-1 downto nt-f) <= b_compact(i)(pt-1 downto pt-f);
        
        a_compact(i+1)(N-1 downto nt) <= (others=>'0');
        b_compact(i+1)(N-1 downto nt) <= (others=>'0');
    
    end generate;
    
    adder_inst: adder
    generic map( N => ht(max_H))
    port map(
        a       => a_compact(max_H)(ht(max_H)-1 downto 0),
        b       => b_compact(max_H)(ht(max_H)-1 downto 0),
        cin     => c_i,
        s       => s_expand(max_H)(ht(max_H)-1 downto 0),
        cout    => c_o);
    s_expand(max_H)(N-1 downto ht(max_H)) <= (others=>'0');
    
    expands: for i in max_H-1 downto 0 generate
        constant pt : integer := ht(i);
        constant nt : integer := ht(i+1);
        constant s : integer := hs(i+1);
        constant f : integer := hf(i+1);
    begin
        s_expand(i)(s-1 downto 0) <= s_expand(i+1)(s-1 downto 0);
        
        expand_gen: for j in 0 to nt-f-s-1 generate
            expand_inst: expand
            port map(
                a1      => a_compact(i)(s+2*j),
                b1      => b_compact(i)(s+2*j),
                a2      => a_compact(i)(s+2*j+1),
                b2      => b_compact(i)(s+2*j+1),
                S_in    => s_expand(i+1)(s+j),
                s1      => s_expand(i)(s+2*j),
                s2      => s_expand(i)(s+2*j+1));   
        end generate;
        
        s_expand(i)(pt-1 downto pt-f) <= s_expand(i+1)(nt-1 downto nt-f);
        
        s_expand(i)(N-1 downto pt) <= (others=>'0');
    end generate;

    res_o <= s_expand(0);
end structural;
