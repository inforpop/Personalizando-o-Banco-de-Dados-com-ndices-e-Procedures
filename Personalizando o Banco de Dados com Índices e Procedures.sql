## Personalizando o Banco de Dados com Índices e Procedures

Para otimizar o desempenho do banco de dados e adicionar funcionalidades avançadas, vamos criar índices nas tabelas e definir algumas stored procedures que auxiliem na operação do sistema.

### Índices

Os índices são utilizados para melhorar a velocidade das consultas em uma tabela. Vamos adicionar índices nas colunas que são frequentemente utilizadas em consultas.

#### Índices nas Tabelas

1. **Clientes**
    ```sql
    CREATE INDEX idx_tipo_cliente ON Clientes(tipo_cliente);
    ```

2. **Clientes_PJ**
    ```sql
    CREATE UNIQUE INDEX idx_cnpj ON Clientes_PJ(cnpj);
    ```

3. **Clientes_PF**
    ```sql
    CREATE UNIQUE INDEX idx_cpf ON Clientes_PF(cpf);
    ```

4. **Pedidos**
    ```sql
    CREATE INDEX idx_data_pedido ON Pedidos(data_pedido);
    CREATE INDEX idx_cliente_pedido ON Pedidos(id_cliente);
    ```

5. **Pagamentos**
    ```sql
    CREATE INDEX idx_pedido_pagamento ON Pagamentos(id_pedido);
    ```

6. **Entregas**
    ```sql
    CREATE INDEX idx_pedido_entrega ON Entregas(id_pedido);
    CREATE INDEX idx_status_entrega ON Entregas(status);
    ```

### Stored Procedures

As stored procedures são blocos de código SQL que podem ser reutilizados. Elas são úteis para encapsular operações complexas ou frequentes.

#### Procedures de Exemplo

1. **Procedure para inserir um novo cliente PF**

    ```sql
    DELIMITER //

    CREATE PROCEDURE InserirClientePF (
        IN nome VARCHAR(100),
        IN endereco VARCHAR(255),
        IN cpf VARCHAR(11),
        IN data_nascimento DATE
    )
    BEGIN
        DECLARE cliente_id INT;
        
        -- Inserir na tabela Clientes
        INSERT INTO Clientes (nome, endereco, tipo_cliente) VALUES (nome, endereco, 'PF');
        
        -- Obter o ID do cliente recém-inserido
        SET cliente_id = LAST_INSERT_ID();
        
        -- Inserir na tabela Clientes_PF
        INSERT INTO Clientes_PF (id_cliente, cpf, data_nascimento) VALUES (cliente_id, cpf, data_nascimento);
    END //

    DELIMITER ;
    ```

2. **Procedure para inserir um novo pedido**

    ```sql
    DELIMITER //

    CREATE PROCEDURE InserirPedido (
        IN id_cliente INT,
        IN data_pedido DATE,
        IN total DECIMAL(10, 2)
    )
    BEGIN
        -- Inserir na tabela Pedidos
        INSERT INTO Pedidos (id_cliente, data_pedido, total) VALUES (id_cliente, data_pedido, total);
    END //

    DELIMITER ;
    ```

3. **Procedure para atualizar o status de uma entrega**

    ```sql
    DELIMITER //

    CREATE PROCEDURE AtualizarStatusEntrega (
        IN id_entrega INT,
        IN novo_status VARCHAR(50),
        IN novo_codigo_rastreio VARCHAR(100)
    )
    BEGIN
        -- Atualizar a tabela Entregas
        UPDATE Entregas 
        SET status = novo_status, codigo_rastreio = novo_codigo_rastreio
        WHERE id_entrega = id_entrega;
    END //

    DELIMITER ;
    ```

4. **Procedure para listar pedidos de um cliente**

    ```sql
    DELIMITER //

    CREATE PROCEDURE ListarPedidosPorCliente (
        IN id_cliente INT
    )
    BEGIN
        -- Selecionar todos os pedidos de um cliente específico
        SELECT 
            p.id_pedido,
            p.data_pedido,
            p.total,
            e.status,
            e.codigo_rastreio
        FROM 
            Pedidos p
        LEFT JOIN 
            Entregas e ON p.id_pedido = e.id_pedido
        WHERE 
            p.id_cliente = id_cliente;
    END //

    DELIMITER ;
    ```

### Consultas Exemplo

Para listar todos os pedidos de um cliente específico:

```sql
CALL ListarPedidosPorCliente(1);
```

Para inserir um novo cliente PF:

```sql
CALL InserirClientePF('João Silva', 'Rua A, 123', '12345678901', '1980-01-01');
```

Para inserir um novo pedido:

```sql
CALL InserirPedido(1, '2024-06-30', 150.00);
```

Para atualizar o status de uma entrega:

```sql
CALL AtualizarStatusEntrega(1, 'Entregue', 'XYZ123456BR');
```

### Considerações Finais

Com a adição de índices e stored procedures, o banco de dados se torna mais eficiente e funcional. Os índices melhoram a performance das consultas, enquanto as stored procedures facilitam operações repetitivas e complexas, promovendo uma melhor manutenção e uso do banco de dados.
