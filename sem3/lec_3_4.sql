ALTER TABLE Tranzactii
ADD CONSTRAINT fk_client_cod
ADD FOREIGN KEY (client_cod) REFERENCES Clienti(cod);