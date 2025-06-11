CREATE TABLE matricula (
    id_matricula INT IDENTITY(1,1) PRIMARY KEY,
    id_clase INT NOT NULL,
    id_profesor INT NOT NULL,
    id_estudiante INT NOT NULL,
    FOREIGN KEY (id_clase) REFERENCES clase(id_clase),
    FOREIGN KEY (id_profesor) REFERENCES profesor(id_profesor),
    FOREIGN KEY (id_estudiante) REFERENCES estudiante(id_estudiante)
);